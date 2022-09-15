#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

source scriptUtils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem
export PEER0_PHYSICS_CA=${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/ca.crt
export PEER0_MATHS_CA=${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/ca.crt
export PEER0_CHEMISTRY_CA=${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/universitymvp.com/orderers/orderer.universitymvp.com/msp/tlscacerts/tlsca.universitymvp.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/universitymvp.com/users/Admin@universitymvp.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="PhysicsMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PHYSICS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/physics.universitymvp.com/users/Admin@physics.universitymvp.com/msp
    export CORE_PEER_ADDRESS=peer0.physics.universitymvp.com:7051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/physics.universitymvp.com/peers/peer0.physics.universitymvp.com/tls/server.key
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="MathsMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MATHS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/maths.universitymvp.com/users/Admin@maths.universitymvp.com/msp
    export CORE_PEER_ADDRESS=peer0.maths.universitymvp.com:9051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/maths.universitymvp.com/peers/peer0.maths.universitymvp.com/tls/server.key
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="ChemistryMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CHEMISTRY_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/users/Admin@chemistry.universitymvp.com/msp
    export CORE_PEER_ADDRESS=peer0.chemistry.universitymvp.com:11051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/chemistry.universitymvp.com/peers/peer0.chemistry.universitymvp.com/tls/server.key
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}