*** Settings ***

Library  RequestsLibrary
Library  JSONLibrary
Library  Collections
Library  OperatingSystem
Library  SeleniumLibrary

*** Variables ***

${base_url}=     http://localhost:8080

*** Test Cases ***
TC1 : Insert single record of working class hero

    create session  mysession   ${base_url}     verify=true
    ${body}=    create dictionary   birthday=09021967   gender=F    name=MIL    natid=01456829      salary=1000     tax=150
    ${response}=    POST On Session  mysession    /calculator/insert    json=${body}  expected_status=202
    status should be  202   ${response}

TC2: Insert single record of working class hero with missing fields

    create session  mysession   ${base_url}     verify=true
    ${body}=    create dictionary   birthday=09021993   gender=F    name=ABC    natid=0130      salary=     tax=150
    ${response}=    POST On Session  mysession  /calculator/insert    json=${body}  expected_status=500
    status should be  500   ${response}

TC3: Insert single record of working class hero with invalid gender value male/female

    create session  mysession   ${base_url}     verify=true
    ${body}=    create dictionary   birthday=09021993   gender=Female    name=ABC    natid=0159      salary=1400     tax=150
    ${response}=    POST On Session  mysession  /calculator/insert    json=${body}  expected_status=500
    status should be  500   ${response}


TC4: Insert multiple record of working class hero
    create session  mysession   ${base_url}     verify=true
    ${body}=    create dictionary   [{ "birthday": 06091993,"gender":"F","name": "Abc12","natid":0126,"salary":10000,"tax":150 },{ "birthday": 22061984,"gender":"M","name": "Abc12","natid":0126,"salary":17890,"tax":567 }]
    ${response}=    POST On Session  ${base_url}/calculator/insertMultiple    json=${body}  expected_status=202
    status should be  202   ${response}
    log to console  ${response.status_code}
    log to console  ${response.content}

TC5: Display the tax relief summary
    ${response}=    GET  ${base_url}/calculator/taxRelief  expected_status=200
    BuiltIn.log to console   ${response.content}
    ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=-$$$$$$$  expected_status=200
    BuiltIn.log to console   ${response.content}
    ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=.00  expected_status=200
    log to console  ${response.content}
    ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=50.00  expected_status=200
    log to console  ${response.status_code}

TC6: Dispense Tax relief
    ${response}=    GET  ${base_url}/dispense  params=query=Dispense!!  expected_status=200
    ${response}=    GET  ${base_url}/dispense  params=query=Cash dispensed  expected_status=200








