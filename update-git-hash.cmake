cmake_minimum_required(VERSION 3.9)

# Get a git hash value. We do not want to use git command here
# because we don't want to make git a build-time dependency.
if(EXISTS "${SOURCE_DIR}/.git/HEAD")
  file(READ "${SOURCE_DIR}/.git/HEAD" HASH)
  string(STRIP "${HASH}" HASH)

  if(HASH MATCHES "^ref: (.*)")
    file(READ "${SOURCE_DIR}/.git/${CMAKE_MATCH_1}" HASH)
    string(STRIP "${HASH}" HASH)
  endif()
endif()

# Create new file contents and update a given file if necessary.
set(NEW_FILE "#include <string>
namespace mold {
std::string mold_git_hash = \"${HASH}\";
}
")

if(EXISTS "${OUTPUT_FILE}")
  file(READ "${OUTPUT_FILE}" OLD_FILE)
endif()

if(NOT "${NEW_FILE}" STREQUAL "${OLD_FILE}")
  file(WRITE "${OUTPUT_FILE}" "${NEW_FILE}")
endif()
