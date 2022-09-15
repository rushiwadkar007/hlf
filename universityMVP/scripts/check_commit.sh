

echo "check commit readiness"
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CC_NAME --version 1 --sequence 1 --init-required --signature-policy "OR ('PhysicsMSP.peer','MathsMSP.peer','ChemistryMSP.peer')" 
