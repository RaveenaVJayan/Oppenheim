*** Settings ***
Library  RequestsLibrary
Library  Collections

*** Variables ***
${base_url}=     http://localhost:8080

*** Test Cases ***
TC1: Insert New Record of Employee
    [Tags]    post
    ${body}=    Create Dictionary    birthday=09021993   gender=F    name=ABC    natid=0129      salary=1000     tax=150
    ${resp}=    POST On Session    ${base_url}/calculator/insert    json=${body}
    log to console  ${resp.status_code}
    log to console  ${resp.content}
    Status Should Be    OK    ${resp}

TC2: Insert New Record of Employee with MissingFields
    [Tags]    post
    ${body}=    Create Dictionary    birthday=09021993   gender=F    name=Raveena    natid=0126      salary=     tax=150
    ${resp}=    POST On Session  ${base_url}/calculator/insert    json=${body}
    log to console  ${resp.status_code}
    log to console  ${resp.content}
    Status Should Be    500   ${resp.status_code}
    Status Should Be    Internal Server Error    ${resp.content}

TC3: Insert Multiple Records of Employee
    [Tags]    post
    ${body}=    Create Dictionary    [{ "birthday":09021993,"gender"="F","name"="Abc12","natid"=0126,"salary"=10000,"tax"=150 },{ "birthday":01011999,"gender"="M","name"="Xyz12","natid"=0134,"salary"=10000,"tax"=150 }]
    ${resp}=    POST    ${base_url}/calculator/insertMultiple    json=${body}
    log to console  ${resp.status_code}
    log to console  ${resp.content}

TC4: Insert Multiple Records of Employee with Missing Fields
    [Tags]    post
    ${body}=    Create Dictionary    [{ "birthday":02081988,"gender"="M","name"="Pqr12","natid"=0138,"salary"=10000,"tax"=150 },{ "birthday":07021979,"gender"="M","name"="Test12","natid"=0137,"salary"=,"tax"=170 }]
    ${resp}=    POST    ${base_url}/calculator/insertMultiple    json=${body}
    log to console  ${resp.status_code}
    log to console  ${resp.content}

TC5: Insert Employee records by uploading CSV file

TC6: Display Tax Relief Summary
    [Tags]    get
    ${resp}=    GET    ${base_url}/calculator/taxReliefSummary
    log to console  ${resp.content}
    Should Be Equal As Strings    ${resp.json()}[method]    GET


TC7: Dispense Tax Relief

ButtonColour
    open browser    ${base_url}     chrome
    ${style}=  Get element attribute   id=check_style@style
    ${color}=   evaluate    re.search("background-color: *(.*?);", '''${style}''').group(1) re

    ${button_name} set variable id:(button )
    element text should be ${button_name}   Dispense Now

    expected_status




