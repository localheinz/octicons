workflow "Octicons" {
  on = "push"
  resolves = [
    "Export SVG from Figma"
  ]
}

action "Install" {
  uses = "actions/npm@master"
  args = "install"
}

action "Version" {
  needs = ["Install"]
  uses = "./.github/actions/version"
}

action "Lint" {
  needs = ["Install"]
  uses = "actions/npm@master"
  args = "run lint"
}

action "Test" {
  needs = ["Lint", "Export SVG from Figma"]
  uses = "actions/npm@master"
  args = "test"
}

action "Export SVG from Figma" {
  uses = "primer/figma-action@refactor"
  secrets = [
    "FIGMA_TOKEN"
  ]
  env = {
    "FIGMA_FILE_URL" = "https://www.figma.com/file/FP7lqd1V00LUaT5zvdklkkZr/Octicons"
  }
  args = [
    "format=svg",
    "outputDir=./lib/build"
  ]
}

action "Build & Deploy node.js" {
  needs = ["Test"]
  uses = "./.github/actions/build_node"
  args = "octicons_node"
  secrets = [
    "NPM_AUTH_TOKEN"
  ]
}

action "Build & Deploy react" {
  needs = ["Test"]
  uses = "./.github/actions/build_node"
  args = "octicons_react"
  secrets = [
    "NPM_AUTH_TOKEN"
  ]
}

action "Build & Deploy rubygem" {
  needs = ["Test"]
  uses = "./.github/actions/build_ruby"
  args = "octicons_gem"
  secrets = [
    "RUBYGEMS_TOKEN"
  ]
}

action "Build & Deploy rails helper" {
  needs = ["Build & Deploy rubygem"]
  uses = "./.github/actions/build_ruby"
  args = "octicons_helper"
  secrets = [
    "RUBYGEMS_TOKEN"
  ]
}

action "Build & Deploy jekyll plugin" {
  needs = ["Build & Deploy rubygem"]
  uses = "./.github/actions/build_ruby"
  args = "octicons_jekyll"
  secrets = [
    "RUBYGEMS_TOKEN"
  ]
}
