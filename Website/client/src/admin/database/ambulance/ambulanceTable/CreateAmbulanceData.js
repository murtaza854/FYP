export function CreateAmbulanceData(obj) {
    const data = {
        id: obj._id,
        driverID: obj.driver._id,
        driver: `${obj.driver.firstName} ${obj.driver.lastName}`,
        numberPlate: obj.numberPlate,
        ambulanceType: obj.ambulanceType.name,
        organization: obj.organization.name,
    };
    return data;
}