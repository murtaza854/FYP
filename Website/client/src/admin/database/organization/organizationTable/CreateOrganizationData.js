export function CreateOrganizationData(obj) {
    const data = {
        id: obj._id,
        name: obj.name,
        count: obj.ambulances.length,
    };
    return data;
}