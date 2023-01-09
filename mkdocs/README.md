#

## Start development server with Podman

```bash
cd resume/mkdocs
podman pull squidfunk/mkdocs-material
podman run --rm -it --security-opt label=disable -v ${PWD}:/docs squidfunk/mkdocs-material build
podman run --rm -it --security-opt label=disable -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
```
