#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}


function PhysicsCCP {
    ORG=1
    P0PORT=7051
    CAPORT=7054
    PEERPEM=organizations/peerOrganizations/physics.universitymvp.com/tlsca/tlsca.physics.universitymvp.com-cert.pem
    CAPEM=organizations/peerOrganizations/physics.universitymvp.com/ca/ca.physics.universitymvp.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/physics.universitymvp.com/connection-physics.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/physics.universitymvp.com/connection-physics.yaml

}

function MathsCCP {
    ORG=2
    P0PORT=9051
    CAPORT=8054
    PEERPEM=organizations/peerOrganizations/maths.universitymvp.com/tlsca/tlsca.maths.universitymvp.com-cert.pem
    CAPEM=organizations/peerOrganizations/maths.universitymvp.com/ca/ca.maths.universitymvp.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/maths.universitymvp.com/connection-maths.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/maths.universitymvp.com/connection-maths.yaml

}

function ChemistryCCP {

    ORG=3
    P0PORT=11051
    CAPORT=9054
    PEERPEM=organizations/peerOrganizations/chemistry.universitymvp.com/tlsca/tlsca.chemistry.universitymvp.com-cert.pem
    CAPEM=organizations/peerOrganizations/chemistry.universitymvp.com/ca/ca.chemistry.universitymvp.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/chemistry.universitymvp.com/connection-chemistry.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/chemistry.universitymvp.com/connection-chemistry.yaml

}