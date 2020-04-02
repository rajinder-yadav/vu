#=============================================================================================
# Vue.js Utility Script - The missing Vue.js CLI
#
# Author: Rajinder Yadav
# Date: March 28, 2020
# Licence: MIT
# Version: 1.6.2
#=============================================================================================
# Copy this "vu.sh" file to your home folder, then add snippet to your .bashrc file.
#
# # User defined functionss for Vue.js
# if [ -f "${HOME}/.vu/vu.sh" ]; then
#     . "${HOME}/.vu/vu.sh"
# fi
#=============================================================================================
# README
#
# Creating a new Vue.js project
# vu new hello-world
#
# Generating a Component called Dashboard. Generated code will be place in the subfolder, "src/components/Dashboard".
# vu g c Dashboard
#
# Generating a View Component called Home. Generated code will be place in the subfolder, "src/views/Dashboard".
# vu g v Home
#
# Generating a Component called Login under subfolder, "src/Admin/Login".
# vu g Admin Login
#
# Starting the development server.
# vu s
#
# Doing a production build.
# vu b
#=============================================================================================
IDE="/usr/bin/code-insiders"

# export CLI_CWD=$(pwd)

function vu() {
    CSS_EXT=$(grep -Po '<style\slang="\K\w*' src/App.vue)

    if [[ -z "$CSS_EXT" ]]; then
        # Fallback style type.
        CSS_EXT="stylus"
    fi

    case ${1} in

        # Command: build
        b)
            npm run build
        ;;

        # Command: new
        new)
            if [[ ! -d ${2} ]]; then
                # Create a new project.
                vue create ${2}
                cd ${2}

                # Need to get this working to open vscode with project.
                # "`${IDE}` $CLI_CWD/$2"
            else
                echo "WARNING: Folder exist! Failed to create Project."
            fi
        ;;

        # Command: generate
        g)
            if [ "$#" -lt 3 ]; then
                ShowUsage
            else
                case ${2} in
                    # Option: component
                    c)
                        # Use default components folder.
                        GenerateComponent "components" ${3}
                    ;;

                    # Option: view
                    v)
                        # Use default components folder.
                        GenerateComponent "views" ${3}
                    ;;

                    # Default: Use specified folder for code generation.
                    *)
                        # Folder & Component name provided.
                        GenerateComponent ${2} ${3}
                    ;;
                esac
            fi
        ;;


        # Command: server
        s)
            # Run development server.
            npm run serve
        ;;

        # Default: Show usage help text
        *)
            ShowUsage
        ;;

    esac
}


function ShowUsage() {
    # Show usage help.
    printf "\nvu the missing Vue.js CLI 😍\n\n"
    printf "Usage: vu <command> [options]\n\n"
    printf "CMD\tOptions\t\t\tDescription\n"
    printf "===\t=======\t\t\t===========\n"
    printf "new\t<name>\t\t\tCreate Vue.js Project.\n"
    printf "b\t\t\t\tProduction build.\n"
    printf "g\tc <name>\t\tGenerate Component under \"components\" folder.\n"
    printf "g\tv <name>\t\tGenerate Component under \"views\" folder.\n"
    printf "g\t<folder> <name>\t\tGenerate Component under declared folder.\n"
    printf "s\t\t\t\tRun development Server.\n\n"
}


function GenerateComponent() {
    # Creat Component.
    # Default Component folder.cd
    FOLDER=${1}
    COMPONENT_NAME=${2}

    if [[ ! -d ./src/${FOLDER}/${COMPONENT_NAME} ]]; then
        echo "Creating Component folder"
        mkdir -p ./src/${FOLDER}/${COMPONENT_NAME}
        echo "Creating Component files"
        touch ./src/${FOLDER}/${COMPONENT_NAME}/${COMPONENT_NAME}.${CSS_EXT}

        GenerateClassFile ${FOLDER} ${COMPONENT_NAME}
        GenerateTemplateFile ${FOLDER} ${COMPONENT_NAME}
    else
        echo "WARNING: Component folder exist, no operation was performed."
    fi
}


function GenerateClassFile() {
FOLDER=${1}
COMPONENT_NAME=${2}
# Generate Class file.
cat >"./src/${FOLDER}/${COMPONENT_NAME}/${COMPONENT_NAME}.ts" <<-EOF
import { Component, Prop, Vue } from "vue-property-decorator";

@Component
export default class ${COMPONENT_NAME} extends Vue {
}
EOF
}


function GenerateTemplateFile() {
FOLDER=${1}
COMPONENT_NAME=${2}

# Generate Template file.
cat >"./src/${FOLDER}/${COMPONENT_NAME}/${COMPONENT_NAME}.vue" <<-EOF
<template>
  <div></div>
</template>

<script lang="ts" src="./${COMPONENT_NAME}.ts" />
<style scoped lang="${CSS_EXT}" src="./${COMPONENT_NAME}.${CSS_EXT}" />
EOF
}
