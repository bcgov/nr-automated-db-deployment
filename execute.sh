#!/bin/bash
process_data() {
  # Read the JSON file
  json=$(cat data.json)

  # Iterate through the array using jq and the .[] syntax
  # The -c flag outputs each element on a single line
  for entry in $(echo "$json" | jq -c '.[]'); do
    # Create variables for each entry using jq
    # The -r flag outputs raw strings without quotes
    repo_name=$(echo "$entry" | jq -r '.repo_name')
    branch_name=$(echo "$entry" | jq -r '.branch_name')
    folders=$(echo "$entry" | jq -c '.folders')
    process_folders "$folders" "$repo_name" "$branch_name" # Call a function to process the folders
    # Do something with the variables
  done
}

process_folders() {
  for folder in $(echo "$1" | jq -c '.[]'); do
    # Create variables for each entry using jq
    # The -r flag outputs raw strings without quotes
    folder_path=$(echo "$folder" | jq -r '.absolute_path')
    type=$(echo "$folder" | jq -r '.type')
    envs=$(echo "$folder" | jq -r '.env')
    create_directory "$folder_path" "$2" "$3"
    # Add switch case for type
    case $type in
      "flyway")
        echo "flyway"
        process_flyway "$folder_path" "$envs" "$2" "$3"
        ;;
      "liquibase")
        echo "liquibase"
         process_liquibase "$folder_path" "$envs" "$2" "$3"
        ;;
      "typeorm")
        echo "typeorm"
        process_typeorm "$folder_path" "$envs" "$2" "$3"
        ;;
      *)
        echo "Invalid type"
        ;;
    esac
  done
}
create_directory() {
  folder_path=$1
  repo_name=$2
  branch_name=$3
  # Create directory
  mkdir -p "$WORKDIR/$repo_name"
  # Clone the repo
  git clone "https://github.com/bcgov/$repo_name.git" "$WORKDIR/$repo_name"
  cd "$WORKDIR/$repo_name" || exit
  git checkout "$branch_name"
}
process_flyway() {
  folder_path=$1
  envs=$2
  repo_name=$3
  branch_name=$4


}
main() {
  # Read the JSON file
  process_data
}

main
