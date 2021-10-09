local repo = "scififarms/" + std.extVar("drone_service_name");
local technocore_version = "1.0";

local pipeline = {
  name: "",
  kind: "pipeline",
  platform: {
    os: "linux",
    arch: "",
  },
  steps: [
    {
      name: "publish",
      image: "plugins/docker",
      pull: 'if-not-exists',
      settings: {
        repo: repo,
        purge: false,
        dry_run: true,
        auto_tag: false,

        auto_tag_suffix: $.platform.os + "-" + $.platform.arch,
        dockerfile: "docker/Dockerfile." + $.platform.arch,
        username: {
          from_secret: "docker_username"
        },
        password: {
          from_secret: "docker_password"
        },
      },
    },
  ],
};

local default_triggers = {
  ref: [
    'refs/heads/master',
    "refs/tags/**",
    "refs/pull/**",
  ],
};

local container_docker_volumes = [
    {
      name: "docker-login",
      path: "/root/.docker/",
    },
    {
      name: "docker_socket",
      path: "/var/run/docker.sock",
    }
];

local host_docker_volumes = [
  {
    name: "docker-login",
    host: {
      path: "/root/.docker/",
    },
  },
  {
    name: "docker_socket",
    host: {
      path: "/var/run/docker.sock",
    },
  },
];

[
    pipeline + {
      name: "amd64_dev",
      platform+: { arch: "amd64"},
      volumes: host_docker_volumes,
      trigger: {
        "repo": ["afake/repo"]
      },
      steps: [
        super.steps[0] + {
          volumes: container_docker_volumes,
          settings+: {
            tags: ["local"],
          },
        },
      ],
    },
    pipeline + {
      name: "amd64_test",
      platform+: { arch: "amd64"},
      trigger: default_triggers,
      steps: [
        super.steps[0] + {
          name: "test",
          settings+: {
            tags: [
              "test",
            ],
            when: [{event: ["pull_request"],}],
          },
        },
      ],
    },
    pipeline + {
      name: "amd64_prod",
      depends_on: ["amd64_test"],
      platform+: { arch: "amd64"},
      trigger: default_triggers,
      steps: [
        super.steps[0] + {
          settings+: {
            dry_run: false,
            tags: [
              "latest",
              "v" + technocore_version,
              "v" + technocore_version + ".${DRONE_BUILD_NUMBER}",
            ],
            when_var: {event: { exclude: ["pull_request"],}},
          },
        },
      ],
    },
]