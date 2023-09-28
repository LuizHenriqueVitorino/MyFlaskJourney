*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
# ${localhost}    http://localhost
${localhost}    http://127.0.0.1
${porta}        5000
${alias}        sale_api
*** Keywords ***
Login e Validar token
    [Arguments]    ${username}          ${password}
    ${Body}        Create Dictionary    username=${username}    password=${password}
    Create Session    alias=${alias}        url=${localhost}:${porta}
    ${RESPONSE}    POST On Session      alias=${alias}          url=/auth/login    json=${Body}
    RETURN         ${RESPONSE}
DADO que o SALE receba uma requisição POST para autenticação
    ${HEADERS}        Create Dictionary     content-type=application-json
    Create Session    alias=${alias}        url=${localhost}:${porta}

QUANDO o sistema validar as credenciais
    ${RESPONSE}    Login e Validar token    email@correto.com    senha_correta
    Log            Resposta Retornada: ${\n}${RESPONSE.text}
    RETURN         ${RESPONSE}

QUANDO o sistema verificar que o/a ${campo} está incorreto/a
    IF    $campo == email
        ${RESPONSE}    Login e Validar token    email@incorreto .com       senha_qualquer
    ELSE
        ${RESPONSE}    Login e Validar token    email@correto.com           senha_incorreta
    END
        Log            Resposta Retornada: ${\n}${RESPONSE.text}
        RETURN         ${RESPONSE}

QUANDO o sistema verificar que o/a ${campo} está em branco
    IF    $campo == email
        ${RESPONSE}    Login e Validar token    ''       senha_qualquer
    ELSE
        ${RESPONSE}    Login e Validar token    email@correto.com           ''
    END
        Log            Resposta Retornada: ${\n}${RESPONSE.text}
        RETURN         ${RESPONSE}
Verifica o Tipo de erro
    [Arguments]                       ${campo}        ${tipo}
    IF    $tipo == incorreto
        ${RESPONSE}                       QUANDO o sistema verificar que o/a ${campo} está incorreto/a
    ELSE
        ${RESPONSE}                       QUANDO o sistema verificar que o/a ${campo} está em branco
    END
        RETURN    ${RESPONSE}
ENTÃO o SALE deve enviar um JSON de resposta contendo o token para o usuário
    ${RESPONSE}                       QUANDO o sistema validar as credenciais
    Log                               Resposta Retornada: ${\n}${RESPONSE}
    Dictionary Should Contain Item    ${RESPONSE.json()}    token    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
    Log                               JSON: ${RESPONSE.json}   

ENTÃO o SALE deve enviar um JSON de resposta contendo um código de erro
    [Arguments]                       ${campo}        ${tipo}
    IF    $tipo == 'incorreto'
        ${RESPONSE}                       QUANDO o sistema verificar que o/a ${campo} está incorreto/a
    ELSE
        ${RESPONSE}                       QUANDO o sistema verificar que o/a ${campo} está em branco
    END
        Log                               Resposta Retornada: ${\n}${RESPONSE}
        # Dictionary Should Contain Item    ${RESPONSE.json()}    statusCode    401
        Dictionary Should Contain Item    ${RESPONSE.json()}      ttl           ${1209600}
        Log                               JSON: ${RESPONSE.json} 
    

*** Test Cases ***
Cenário 1: Autenticação com email e senha corretos
    [Tags]    Funcionalidade 01    [TC-01] Autenticação com credenciais corretas
    DADO que o SALE receba uma requisição POST para autenticação
    QUANDO o sistema validar as credenciais
    ENTÃO o SALE deve enviar um JSON de resposta contendo o token para o usuário

Cenário 1: Requisição com email inexistente
    [Tags]    Funcionalidade 01    [TC-02] Autenticação com credenciais incorretas
    DADO que o SALE receba uma requisição POST para autenticação
    QUANDO o sistema verificar que o/a email está incorreto/a
    ENTÃO o SALE deve enviar um JSON de resposta contendo um código de erro    email        incorreto

Cenário 2: Requisição com senha inexistente
    [Tags]    Funcionalidade 01    [TC-02] Autenticação com credenciais incorretas
    DADO que o SALE receba uma requisição POST para autenticação
    QUANDO o sistema verificar que o/a senha está incorreto/a
    ENTÃO o SALE deve enviar um JSON de resposta contendo um código de erro    senha        incorreto

Cenário 1: Autenticação com email em branco
    [Tags]    Funcionalidade 01    [TC-03] Autenticação com credenciais em branco
    DADO que o SALE receba uma requisição POST para autenticação
    QUANDO o sistema verificar que o/a email está em branco
    ENTÃO o SALE deve enviar um JSON de resposta contendo um código de erro    email    branco

Cenário 2: Autenticação com senha em branco
    [Tags]    Funcionalidade 01    [TC-03] Autenticação com credenciais em branco
    DADO que o SALE receba uma requisição POST para autenticação
    QUANDO o sistema verificar que o/a senha está em branco
    ENTÃO o SALE deve enviar um JSON de resposta contendo um código de erro    senha    branco
Cenário 3: Autenticação com email e senha em branco
    [Tags]    Funcionalidade 01    [TC-03] Autenticação com credenciais em branco
    DADO que o SALE receba uma requisição POST para autenticação
    QUANDO o sistema verificar que o/a senha e email está em branco
    ENTÃO o SALE deve enviar um JSON de resposta contendo um código de erro    email e senha    branco