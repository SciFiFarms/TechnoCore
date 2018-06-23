====== NodeRED Documentation ======

===== Debugging NodeRED =====
In order to debug NodeRED, there are some tweaks that need to happen.
  - Setup Debugging in your IDE. In VS Code I used the following: 
<code>
        {
            "type": "node",
            "request": "attach",
            "name": "Debug NodeJS",
            "address": "localhost",
            "port": 9229, 
            "localRoot": "/home/spencer/src/althing/node-red/",
            "remoteRoot": "/usr/src/node-red/"
        }
</code>
  - Add debugging port to docker-compose.yml. 
<code>
      - "9229:9229"
</code>
  - Add "--inspect" to the "start" object in /usr/src/node-red/package.json
    * This should be doable via env var, but seems to be blocked. https://nodejs.org/api/cli.html#cli_node_options
    * The easiest way I've found to do this is copy the package from the container. <code>
docker cp [CONTAINER_HASH]:/usr/src/node-red/package.json . </code> 
Add the --inspect flag to that file, and then bind mount it. <code>
      - "./package.json:/usr/src/node-red/package.json"
</code>
Alternatively, you can snag all the NodeRED code and mount that instead. 




Walk through on how to  debug Docker, TypeScript, and Node:
https://github.com/Microsoft/vscode-recipes/tree/master/Docker-TypeScript

More ideas on how to debug node in docker:
https://github.com/Microsoft/vscode-node-debug/issues/29
Cool

