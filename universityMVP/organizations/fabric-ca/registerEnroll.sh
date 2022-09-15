#!/bin/bash

source scriptUtils.sh
export PATH=${PWD}/../bin:$PATH
function createPhysics() {
  mkdir channel-artifacts
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/physics.universitymvp.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/physics.universitymvp.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-physics --tls.certfiles ${PWD}/organizations/fabric-ca/physics/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-physics.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-physics.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-physics.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-physics.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/physics.universitymvp.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-physics --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/physics/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-physics --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/physics/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-physics --id.name physicsadmin --id.secret physicsadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/physics/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/physics.universitymvp.com/peers
  mkdir -p organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-physics -M ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/msp --csr.hosts peer0.physics.universitymvp.com --tls.certfiles ${PWD}/organizations/fabric-ca/physics/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-physics -M ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls --enrollment.profile tls --csr.hosts peer0.physics.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/physics/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/tlsca/tlsca.physics.universitymvp.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/ca
  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/ca/ca.physics.universitymvp.com-cert.pem

  mkdir -p organizations/peerOrganizations/physics.universitymvp.com/users
  mkdir -p organizations/peerOrganizations/physics.universitymvp.com/users/User1@physics.universitymvp.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-physics -M ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/users/User1@physics.universitymvp.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/physics/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/users/User1@physics.universitymvp.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/physics.universitymvp.com/users/Admin@physics.universitymvp.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://physicsadmin:physicsadminpw@localhost:7054 --caname ca-physics -M ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/users/Admin@physics.universitymvp.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/physics/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/physics.universitymvp.com/users/Admin@physics.universitymvp.com/msp/config.yaml

}

function createMaths() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/maths.universitymvp.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/maths.universitymvp.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-maths --tls.certfiles ${PWD}/organizations/fabric-ca/maths/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-maths.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-maths.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-maths.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-maths.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/maths.universitymvp.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-maths --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/maths/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-maths --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/maths/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-maths --id.name mathsadmin --id.secret mathsadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/maths/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/maths.universitymvp.com/peers
  mkdir -p organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-maths -M ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/msp --csr.hosts peer0.maths.universitymvp.com --tls.certfiles ${PWD}/organizations/fabric-ca/maths/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-maths -M ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls --enrollment.profile tls --csr.hosts peer0.maths.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/maths/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/tlsca/tlsca.maths.universitymvp.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/ca
  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/ca/ca.maths.universitymvp.com-cert.pem

  mkdir -p organizations/peerOrganizations/maths.universitymvp.com/users
  mkdir -p organizations/peerOrganizations/maths.universitymvp.com/users/User1@maths.universitymvp.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-maths -M ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/users/User1@maths.universitymvp.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/maths/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/users/User1@maths.universitymvp.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/maths.universitymvp.com/users/Admin@maths.universitymvp.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://mathsadmin:mathsadminpw@localhost:8054 --caname ca-maths -M ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/users/Admin@maths.universitymvp.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/maths/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/maths.universitymvp.com/users/Admin@maths.universitymvp.com/msp/config.yaml

}



function createChemistry() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/chemistry.universitymvp.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-chemistry --tls.certfiles ${PWD}/organizations/fabric-ca/chemistry/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-chemistry.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-chemistry.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-chemistry.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-chemistry.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-chemistry --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/chemistry/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-chemistry --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/chemistry/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-chemistry --id.name chemistryadmin --id.secret chemistryadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/chemistry/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/chemistry.universitymvp.com/peers
  mkdir -p organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-chemistry -M ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/msp --csr.hosts peer0.chemistry.universitymvp.com --tls.certfiles ${PWD}/organizations/fabric-ca/chemistry/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-chemistry -M ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls --enrollment.profile tls --csr.hosts peer0.chemistry.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/chemistry/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/tlsca/tlsca.chemistry.universitymvp.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/ca
  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/ca/ca.chemistry.universitymvp.com-cert.pem

  mkdir -p organizations/peerOrganizations/chemistry.universitymvp.com/users
  mkdir -p organizations/peerOrganizations/chemistry.universitymvp.com/users/User1@chemistry.universitymvp.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-chemistry -M ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/users/User1@chemistry.universitymvp.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/chemistry/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/users/User1@chemistry.universitymvp.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/chemistry.universitymvp.com/users/Admin@chemistry.universitymvp.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://chemistryadmin:chemistryadminpw@localhost:9054 --caname ca-chemistry -M ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/users/Admin@chemistry.universitymvp.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/chemistry/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/users/Admin@chemistry.universitymvp.com/msp/config.yaml

}




function createOrderer() {

  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/ordererOrganizations/universitymvp.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/universitymvp.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Register orderer2"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register orderer3"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Register orderer4"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer4 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register orderer5"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer5 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null




  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers
  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers/universitymvp.com

  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/msp --csr.hosts orderer.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls --enrollment.profile tls --csr.hosts orderer.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem

  mkdir -p organizations/ordererOrganizations/universitymvp.com/users
  mkdir -p organizations/ordererOrganizations/universitymvp.com/users/Admin@universitymvp.com


  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com

  infoln "Generate the orderer2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/msp --csr.hosts orderer2.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/msp/config.yaml

  infoln "Generate the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls --enrollment.profile tls --csr.hosts orderer2.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer2.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem



  # -----------------------------------------------------------------------
  #  Orderer 3

  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com

  infoln "Generate the orderer3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/msp --csr.hosts orderer3.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/msp/config.yaml

  infoln "Generate the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls --enrollment.profile tls --csr.hosts orderer3.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer3.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem




  # -----------------------------------------------------------------------
  #  Orderer 4

  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com

  infoln "Generate the orderer4 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/msp --csr.hosts orderer4.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/msp/config.yaml

  infoln "Generate the orderer4-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls --enrollment.profile tls --csr.hosts orderer4.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer4.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem




  # -----------------------------------------------------------------------
  #  Orderer 5

  mkdir -p organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com

  infoln "Generate the orderer5 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/msp --csr.hosts orderer5.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/msp/config.yaml

  infoln "Generate the orderer5-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls --enrollment.profile tls --csr.hosts orderer5.universitymvp.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer5.universitymvp.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem



  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/universitymvp.com/users/Admin@universitymvp.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/universitymvp.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/universitymvp.com/users/Admin@universitymvp.com/msp/config.yaml

}
