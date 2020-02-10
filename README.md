# docker-elixir-yarn
Docker image for CI builds that combines Elixir and Node+Yarn. Hosted on Docker Hub here: [skrebbel/docker-elixir-yarn](https://hub.docker.com/repository/docker/skrebbel/docker-elixir-yarn)

We use this at TalkJS for our CI builds. No promises that it's good for anything else!

To make changes from inside GitHub UI, do:
- Edit the Dockerfile by opening it and clicking "Edit", then commit
- Assuming you version bumped something, create a new tag by going to "releases" and clicking "Create new release". That's just `git tag` for the lazy.
- Docker Hub is now going to autobuild stuff.
- Update the reference to [skrebbel/docker-elixir-yarn](https://hub.docker.com/repository/docker/skrebbel/docker-elixir-yarn) inside wherever you're using it (eg circle.yml)
