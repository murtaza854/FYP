export function CreateUserData(obj) {
    const data = {
        id: obj._id,
        name: `${obj.firstName} ${obj.lastName}`,
        email: obj.email,
        contactNumber: obj.contactNumber,
        accountSetup: obj.accountSetup,
        role: obj.role,
        isActive: obj.isActive,
    }
    if (obj.accountSetup) {
        if (obj.role === 'Driver') {
            data.trips = obj.trips;
            data.averageResponseTime = obj.trips.reduce((acc, curr) => acc + curr.responseTime, 0) / obj.trips.length;
            data.averageCommuteTime = obj.trips.reduce((acc, curr) => acc + curr.commuteTime, 0) / obj.trips.length;
            data.totalKilometersTravelled = obj.trips.reduce((acc, curr) => acc + curr.distanceTravelledToDestination, 0);
            data.generateDataSetsAverageResponseTime = function () {
                const dataSetsObj = {}
                const labels = [3, 6, 9, 12, 15, 18, 21, 24];
                obj.trips.forEach((trip) => {
                    const hour = new Date(trip.startTime).getHours();
                    for (let i = 0; i < labels.length; i++) {
                        if (!(labels[i] in dataSetsObj)) {
                            dataSetsObj[labels[i]] = [];
                        }
                        if (labels[i + 1] && hour >= labels[i] && hour < labels[i + 1]) {
                            dataSetsObj[labels[i]].push(trip.responseTime);
                        } else if (!labels[i + 1]) {
                            if (hour < labels[0] && hour >= 0) {
                                dataSetsObj[labels[i]].push(trip.responseTime);
                            }
                        }
                    }
                });
                const dataSets = [];
                for (const key in dataSetsObj) {
                    if (Object.hasOwnProperty.call(dataSetsObj, key)) {
                        const element = dataSetsObj[key];
                        if (element.length > 0) {
                            // find average of the array
                            const average = element.reduce((acc, curr) => acc + curr, 0) / element.length;
                            dataSets.push(average);
                        }
                    }
                }
                return [10, 5.5, 7, 15, 13.67, 22, 9, 12.56];
            }
            data.generateDataSetsAverageCommuteTime = function () {
                const dataSetsObj = {}
                const labels = [3, 6, 9, 12, 15, 18, 21, 24];
                obj.trips.forEach((trip) => {
                    const hour = new Date(trip.startTime).getHours();
                    for (let i = 0; i < labels.length; i++) {
                        if (!(labels[i] in dataSetsObj)) {
                            dataSetsObj[labels[i]] = [];
                        }
                        if (labels[i + 1] && hour >= labels[i] && hour < labels[i + 1]) {
                            dataSetsObj[labels[i]].push(trip.commuteTime);
                        } else if (!labels[i + 1]) {
                            if (hour < labels[0] && hour >= 0) {
                                dataSetsObj[labels[i]].push(trip.commuteTime);
                            }
                        }
                    }
                });
                const dataSets = [];
                for (const key in dataSetsObj) {
                    if (Object.hasOwnProperty.call(dataSetsObj, key)) {
                        const element = dataSetsObj[key];
                        if (element.length > 0) {
                            // find average of the array
                            const average = element.reduce((acc, curr) => acc + curr, 0) / element.length;
                            dataSets.push(average);
                        }
                    }
                }
                return [50, 35.5, 40, 20, 35.67, 17, 20, 25.56];
            }
            data.numberOfAcceptedTrips = obj.numberOfAcceptedTrips;
            data.numberOfRejectedTrips = obj.numberOfRejectedTrips;
            data.numberOfCancelledTrips = obj.numberOfCancelledTrips;
            data.numberOfCompletedTrips = obj.numberOfCompletedTrips;
        } else if (obj.role === 'Patient') {
            data.medicalCard = obj.medicalCard;
            data.addresses = obj.addresses;
            data.emergencyContacts = obj.emergencyContacts;
        } else {
            data.error = 'Invalid role';
        }
    }
    console.log(data);
    return data;
}