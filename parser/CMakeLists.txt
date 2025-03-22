get_filename_component(CURRENT_FOLDER_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
set(artifact "${CURRENT_FOLDER_NAME}")

set(PARSER_DIR "${CMAKE_CURRENT_BINARY_DIR}")
set(FLEX_OUTPUT "${PARSER_DIR}/lexer.cpp")
set(BISON_OUTPUT "${PARSER_DIR}/parser.cpp")

FLEX_TARGET(lexer lexer.l ${FLEX_OUTPUT} DEFINES_FILE ${PARSER_DIR}/lexer.h)
BISON_TARGET(parser parser.y ${BISON_OUTPUT} DEFINES_FILE ${PARSER_DIR}/parser.h)
ADD_FLEX_BISON_DEPENDENCY(lexer parser)

file(GLOB_RECURSE dir CONFIGURE_DEPENDS src/*.cxx src/*.c src/*.cpp include/*.h include/*.hpp)
add_library(${artifact} STATIC ${FLEX_OUTPUT} ${BISON_OUTPUT} ${FLEX_Scanner_OUTPUTS} ${BISON_Parser_OUTPUTS} ${dir})
target_include_directories(${artifact} PUBLIC include ${CMAKE_CURRENT_BINARY_DIR})
# include_directories(${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(${artifact} PUBLIC bits y)