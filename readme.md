*This project has been created as part of the 42 curriculum by joseo.*

# Resources
[docker](https://docs.docker.com/get-started/docker-overview/) learning docker.
[Containers](https://wizardzines.com/zines/containers/) How containers work.
[CMD_ENTRYPOINT](https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/) CMD vs ENTRYPOINT

# Docker
- It is a way to package and run applications in an environment that is seperate from the host.
- It lets the application to be run on anything with docker.
- Kind of like a packager that has a server close to git.

- PID1
    The first process started during the system boot.
    All other processes are started by PID1.
    It manages all other porcesses inside in the container.

- CMD
    The instruction specifies the default command to run when a container is started from the docker image. If no command the default is used.

- ENTRYPOINT
    Sets the default executable for the container
    Use it when a base command is always needed to run. for example always the same args

## Objects
- Images
    Basicly the namespace that you want the project/application to have.
    It is the read-only template that instructs how to create the docker container.

- Containers
    A runable instance of the image.
    It is quite isolated from other containers and host machines and networks.
    Virtual machines virtualize an entire machine down to hardware layers whereas containers only virtualize software layers above the operating systems
