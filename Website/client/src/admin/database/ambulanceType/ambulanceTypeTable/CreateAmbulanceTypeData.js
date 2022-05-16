export function CreateAmbulanceTypeData(obj) {
    const data = {
        id: obj._id,
        name: obj.name,
    };
    return data;
}