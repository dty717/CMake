set(EXPERIMENTAL_FEATURE_REGEX "<Subproject name=\"MyExperimentalFeature\">.*<Label>MyExperimentalFeature</Label>.*</Subproject>")
set(PRODUCTION_CODE_REGEX "<Subproject name=\"MyProductionCode\">.*<Label>MyProductionCode</Label>.*</Subproject>")
set(SUBPROJECTS_REGEX "${EXPERIMENTAL_FEATURE_REGEX}.*${PRODUCTION_CODE_REGEX}")

file(GLOB configure_xml_file "${RunCMake_TEST_BINARY_DIR}/Testing/*/Configure.xml")
if(configure_xml_file)
  file(READ "${configure_xml_file}" configure_xml)
  if(NOT configure_xml MATCHES "${SUBPROJECTS_REGEX}.*<Configure>")
     set(RunCMake_TEST_FAILED "Configure.xml does not contain the expected list of subprojects")
  endif()
else()
  set(RunCMake_TEST_FAILED "Configure.xml not found")
endif()

file(GLOB build_xml_file "${RunCMake_TEST_BINARY_DIR}/Testing/*/Build.xml")
if(build_xml_file)
  file(READ "${build_xml_file}" build_xml)
  set(BUILD_WARNING_REGEX "<Failure type=\"Warning\">.*<Labels>.*<Label>MyExperimentalFeature</Label>.*</Labels>")
  if(NOT build_xml MATCHES "${SUBPROJECTS_REGEX}.*<Build>.*${BUILD_ERROR_REGEX}.*</Build>")
    set(RunCMake_TEST_FAILED "Build.xml does not contain the expected list of subprojects and labels")
  endif()
else()
  set(RunCMake_TEST_FAILED "Build.xml not found")
endif()

file(GLOB test_xml_file "${RunCMake_TEST_BINARY_DIR}/Testing/*/Test.xml")
if(test_xml_file)
  file(READ "${test_xml_file}" test_xml)
  set(TEST_FAILED_REGEX "<Test Status=\"failed\">.*<Labels>.*<Label>MyExperimentalFeature</Label>.*<Label>NotASubproject</Label>.*</Labels>")
  set(TEST_PASSED_REGEX "<Test Status=\"passed\">.*<Labels>.*<Label>MyProductionCode</Label>.*</Labels>")
  if(NOT test_xml MATCHES "${SUBPROJECTS_REGEX}.*<Testing>.*${TEST_FAILED_REGEX}.*${TEST_PASSED_REGEX}.*${TEST_NOTRUN_REGEX}.*</Testing>")
    set(RunCMake_TEST_FAILED "Test.xml does not contain the expected list of subprojects and labels")
  endif()
else()
  set(RunCMake_TEST_FAILED "${CTEST_BINARY_DIRECTORY}/Testing/*/Test.xml not found")
endif()