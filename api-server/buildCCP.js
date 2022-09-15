const { buildCCPPhysics, buildCCPMaths, buildCCPChemistry } = require("./AppUtils");

exports.getCCP = (org) => {
    let ccp;
    switch (org) {
        case 1:
            ccp = buildCCPPhysics();
            break;
        case 2:
            ccp = buildCCPMaths();
            break;
        case 3:
            ccp = buildCCPChemistry();
            break;
    }
    return ccp;
}