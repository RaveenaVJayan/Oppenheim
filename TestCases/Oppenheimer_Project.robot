*** Settings ***

Library  RequestsLibrary
Library  JSONLibrary
Library  Collections
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary
Library  OperatingSystem
Library  SeleniumLibrary
Library  DateTime
Library  CSVLib
Variables   ./data.yaml

*** Variables ***

${base_url}=     http://localhost:8080

*** Test Case ***
TC1 : Insert single record of working class hero
    create session  mysession   ${base_url}     verify=true
    ${body}=    create dictionary   birthday=09021993   gender=F    name=ABC    natid=0129      salary=1000     tax=150
    ${response}=    POST On Session  mysession    /calculator/insert    json=${body}  expected_status=202
    status should be  202   ${response}

TC2: Insert single record of working class hero with missing fields
    create session  mysession   ${base_url}     verify=true
    ${body}=    create dictionary   birthday=04061991   gender=M    name=XYZ    natid=0130      salary=     tax=150
    ${response}=    POST On Session  mysession  /calculator/insert    json=${body}  expected_status=500
    status should be  500   ${response}

TC3: Insert single record of working class hero with invalid gender value male/female
    create session  mysession   ${base_url}     verify=true
    ${body}=    create dictionary   birthday=09021993   gender=Female    name=ABC    natid=0159      salary=1400     tax=150
    ${response}=    POST On Session  mysession  /calculator/insert    json=${body}  expected_status=500
    status should be  500   ${response}

TC4: Insert multiple record of working class hero
    #Work in progress
    create session  mysession   ${base_url}     verify=true
    log to console   ${REQUESTDATA.insert_multiple.records}
    #${RESPONSE} =    POST On Session    mysession    /calculator/insertMultiple      ${REQUESTDATA.insert_multiple.records}
    #status should be  202   ${response}

TC5:Insert records by uploading CSV file
    ${list}=     read csv as list    data.csv
    #First row of CSV file
    Should Be Equal As Strings    ${list[0][0]}    birthday
    Should Be Equal As Strings    ${list[0][1]}    gender
    Should Be Equal As Strings    ${list[0][2]}    name
    Should Be Equal As Strings    ${list[0][3]}    natid
    Should Be Equal As Strings    ${list[0][4]}    salary
    Should Be Equal As Strings    ${list[0][5]}    tax

    #Subsequent rows of CSV file
    Should Be Equal As Strings    ${list[1][0]}    20062009
    Should Be Equal As Strings    ${list[1][1]}    F
    Should Be Equal As Strings    ${list[1][3]}    777-$$$$$$$
    Should Be Equal As Strings    ${list[1][4]}    3000
    Should Be Equal As Strings    ${list[1][5]}    150

TC6: Display NatID, Tax Relief , Name
    ${response}=    GET  ${base_url}/calculator/taxRelief  expected_status=200
    BuiltIn.log to console   ${response.content}

TC7: Mask the NatID from 5th character
    ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=-$$$$$$$  expected_status=200
    BuiltIn.log to console   ${response.content}

TC8: Calculate Tax Relief with the formula
    create session  mysession   ${base_url}
    ${emp_dob}  BuiltIn.Set Variable     1994.02.09
    ${Sal}  BuiltIn.Set Variable  3500
    ${Tax}  BuiltIn.Set Variable  200
    ${emp_year} =	Convert Date     ${emp_dob}      result_format=%Y
    ${date}=      Get Current Date      UTC      exclude_millis=yes
    ${date_year} =	Convert Date	${date}	    result_format=%Y
    ${age}=     Evaluate     ${date_year}-${emp_year}
    ${gender} =   set Variable  F
    ${salary}=  Set Variable    3000
    ${tax}=     Set Variable    200
    ${var} =  Set Variable If
    ...  "${age}"<="18"  1
    ...  "${age}"<="35"  0.8
    ...  "${age}"<="50"  0.5
    ...  "${age}"<="75"  0.367
    ...  "${age}">="76"  0.05
    ...  Final else!
    ${bonus} =  Set Variable If
    ...  "${gender}"=="M"  0
    ...  "${gender}"=="F"  500
    ...  Final else!
    ${Data}=   Evaluate     ${salary}- ${tax}
    ${Tax_Relief}=   Evaluate   ${Data}* ${var}+${bonus}
    Log To Console  ${Tax_Relief}

TC9: Rounding of Tax Relief
     ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=.00  expected_status=200
     log to console  ${response.content}
     ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=50.00  expected_status=200
     log to console  ${response.status_code}

TC10: Verify the red colored "Dispense now" button and Cash dispensed page
    Open Browser     ${base_url}   chrome
    ${property}=  Get web element   xpath:/html/body/div/div[2]/div/a[2]
    ${bgcolor}=   Call Method   ${property}     value_of_css_property       background-color
    ${redcolor}=     Set Variable    rgba(220, 53, 69, 1)
    Run Keyword If  '${redcolor}' == '${bgcolor}'    log to console       Background color is red
    Close Browser
    ${response}=    GET  ${base_url}/dispense  params=query=Dispense!!  expected_status=200
    ${response}=    GET  ${base_url}/dispense  params=query=Cash dispensed  expected_status=200


