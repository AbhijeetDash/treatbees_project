const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { DataSnapshot } = require('firebase-functions/lib/providers/database');
admin.initializeApp(functions.config().firebase);

exports.createUser = functions.https.onCall((data, context) => {
    const user = admin.firestore().collection("Users");
    return user.doc(`${data[0].userEmail}`).get().then((val) => {
        if (val.exists) {
            user.doc(`${data[0].userEmail}`).update({
                "msgToken": data[0].msgToken,
                "userPhone": data[0].userPhone,
                "address": data[0].address,
            });
            return { data: val.data() };
        }

        return user.doc(`${data[0].userEmail}`).create({
            "userEmail": data[0].userEmail,
            "userPhone": data[0].userPhone,
            "userName": data[0].userName,
            "address": data[0].address,
            "msgToken": data[0].msgToken
        });
    });
});

exports.getCurrentUser = functions.https.onCall((data, context) => {
    const user = admin.firestore().collection('Users').doc(`${data[0].userMail}`);
    return user.get().then((val) => val.data());
});

exports.createOrder = functions.https.onCall((data, context) => {
    var datetime = new Date();
    var today = data[0].today;
    var time = datetime.getHours() + ' : ' + datetime.getMinutes();
    const cafe = admin.firestore().collection(`${data[0].cafecode}`);
    const user = admin.firestore().collection('Users').doc(`${data[0].userMail}`).collection(`${today}`);
    user.doc(`${data[0].orderTime}|${time}`).create({
        "cafeCode": data[0].cafecode,
        "orderItems": data[0].orderItems,
        "paymentID": data[0].paymentID,
        "orderDate": today,
        "orderTime": data[0].orderTime,
        "orderStatus": data[0].orderStatus,
        "orderType": data[0].orderType,
        "cafeName": data[0].cafeName,
        "useraddress" : data[0].useraddress
    });
    return cafe.doc('CafeOrders').collection(`${today}`).doc(`${data[0].orderTime}|${time}`).create({
        "orderBy": data[0].userMail,
        "userName": data[0].userName,
        "orderByPhone": data[0].userPhone,
        "orderItems": data[0].orderItems,
        "paymentID": data[0].paymentID,
        "orderDate": today,
        "orderTime": data[0].orderTime,
        "orderStatus": data[0].orderStatus,
        "orderType": data[0].orderType,
        "cafeName": data[0].cafeName,
        "useraddress" : data[0].useraddress
    })
});

exports.createGroup = functions.https.onCall((data, context) => {
    const group = admin.firestore().collection('Groups');
    return group.doc(data[0].groupName).create({
        "adminMail": data[0].adminMail,
        "groupName": data[0].groupName
    })
});

exports.getGroups = functions.https.onCall((data, context) => {
    const group = admin.firestore().collection('Groups');
    return group.get().then((snapshot) => snapshot.docs);
})

exports.getCarousels = functions.https.onCall((data, context) => {
    const carousels = admin.firestore().collection('Carousels');
    return carousels.get().then((snapshot) => {
        var caro = [];
        snapshot.forEach(doc => {
            caro.push({
                "ID": doc.id,
                "data": doc.data()
            })
        });
        return caro;
    });
})

exports.getCurrentOrders = functions.https.onCall((data, context) => {
    const orders = admin.firestore().collection('Users').doc(`${data[0].userMail}`).collection(`${data[0].OF}`);
    return orders.get().then((snapshot) => {
        var orders = [];
        snapshot.forEach(doc => {
            orders.push({
                "ID": doc.id,
                "data": doc.data()
            })
        });
        return orders;
    })
})

exports.getAllCafe = functions.https.onCall(async (data, context) => {
    var arry = [];
    const owners = admin.firestore().collection('Owners');
    const snap = await owners.get();
    var listCafeCodes = [];
    for(doc of snap.docs){
        listCafeCodes.push(doc.data()['CafeCode']);
    }
    var unique = Array.from(new Set(listCafeCodes));
    for (doc of unique) {
        const cafe = admin.firestore().collection(doc);
        await cafe.doc('INFO').get().then((data) => {
            arry.push({
                "INFO": data.data()
            });
        });
    }
    return arry
})


exports.sendNotificationToOwner = functions.https.onCall((data, context) => {
    const status = data[0]['status'];
    const cafeCode = data[0]['cafeCode'];

    const cafes = admin.firestore().collection('Owners').where("CafeCode", '==', cafeCode);
    cafes.get().then((cafeData) => {
        console.log(cafeData);
        cafeData.forEach((cafe) => {
            var token = cafe.data()['msgToken']
            switch (status) {
                case "accepted":
                    msg = "Order have been accepted."
                    break;
                case "rejected":
                    msg = "Sorry, cafe can't accept that order\nat the moment."
                    break;
                case "preparing":
                    msg = "Your order is being prepared."
                    break;
                case "ready":
                    msg = "Your order is ready to pick-up."
                    break;
                case "Placed":
                    msg = "You have a new Order."
                    break;
                case "cancle":
                    msg = "One Order is cancelled"
                    break;
                default:
                    break;
            }
            var payload = {
                'notification': {
                    'title': "Order " + status,
                    'body': msg,
                    'sound': 'default',
                },
                'data': {}
            };
            admin.messaging().sendToDevice(token, payload).then((val) => { });
        })
    });
})

exports.verifyCafe = functions.https.onCall((data, context) => {
    const code = data[0]['code'];
    const ownerEmail = data[0]['email'];
    const CafeCollection = admin.firestore().collection(`${code}`).doc('INFO');
    return CafeCollection.get().then((val) => {
        
        if(val.data()){
        const status = val.data()['#VerificationStatus'];
        if (status == 'Unverified') {
            const owner = admin.firestore().collection('Owners');
            owner.doc(`${ownerEmail}`).create({
                "CafeCode": code,
                "msgToken": data[0]['msgToken']
            }).then((val) => { }).catch((onError) => { })
            CafeCollection.update({
                "#VerificationStatus": "Verified",
            }).then((val) => {
                return false;
            }).catch((onerror) => { });
        } else {
            const owner = admin.firestore().collection('Owners');
            owner.doc(`${ownerEmail}`).get().then((val) => {
                if (val.exists) {
                    owner.doc(`${ownerEmail}`).update({
                        "CafeCode": code,
                        "msgToken": data[0]['msgToken']
                    })
                } else {
                    owner.doc(`${ownerEmail}`).create({
                        "CafeCode": code,
                        "msgToken": data[0]['msgToken']
                    }).then((val) => { }).catch((onError) => { })
                }
            }).catch((onError) => { })
            return true;
        }
        } else {
            return false;
        }
    });
});

exports.verifyOwner = functions.https.onCall((data, context) => {
    const email = data[0]['email'];
    const ownerList = admin.firestore().collection('Owners').doc(`${email}`);
    return ownerList.get().then((value) => value.data());
});

exports.isMenu = functions.https.onCall((data, context) => {
    const cafeCode = data[0]['cafeCode'];
    const menu = admin.firestore().collection(cafeCode).doc('MENU');
    return menu.get().then((val) => {
        return val.exists;
    })
})

exports.updateOrderStatus = functions.https.onCall((data, context) => {
    const newStatus = data[0]['status'];
    const cafe = admin.firestore().collection(`${data[0].cafecode}`);
    const user = admin.firestore().collection('Users').doc(`${data[0].userMail}`).collection(`${data[0].today}`);
    user.doc(`${data[0].orderID}`).update({
        "orderStatus": data[0].orderStatus
    });
    return cafe.doc('CafeOrders').collection(`${data[0].today}`).doc(`${data[0].orderID}`).update({
        "orderStatus": data[0].orderStatus
    });
});

exports.createMenu = functions.https.onCall((data, context) => {
    const save = data[0].save;
    const categories = data[0].categories;
    const menuItems = data[0].menuItems;
    const code = data[0].code;
    const cateStore = admin.firestore().collection(`${code}`).doc('MENU').collection('Categories');
    const itemStore = admin.firestore().collection(`${code}`).doc('MENU').collection('Items');

    if (save) {
        cateStore.doc('cateName').create({
            "categories": categories
        });
        return itemStore.doc('itemName').create({
            "items": menuItems
        }).then((val) => {
            return true;
        });
    } else {
        cateStore.doc('cateName').update({
            "categories": categories
        });
        return itemStore.doc('itemName').update({
            "items": menuItems
        }).then((val) => {
            return true;
        });
    }

});

exports.getMenu = functions.https.onCall((data, context) => {
    const code = data[0].code;
    const cateStore = admin.firestore().collection(`${code}`).doc('MENU').collection('Categories');
    const itemStore = admin.firestore().collection(`${code}`).doc('MENU').collection('Items');
    var menu = [];
    return cateStore.doc('cateName').get().then((categories) => {
        menu.push({ "Categories": categories.data() });
        return itemStore.doc('itemName').get().then((items) => {
            menu.push({ "Items": items.data() });
            return menu;
        })
    })
});

exports.sendNotification = functions.https.onCall((data, context) => {
    const status = data[0]['status'];
    const userEmail = data[0]['userEmail'];

    const users = admin.firestore().collection('Users').doc(userEmail);
    users.get().then((userData) => {
        const msgToken = userData.data()['msgToken'];
        var msg = "";
        switch (status) {
            case "accepted":
                msg = "Order have been accepted."
                break;
            case "rejected":
                msg = "Sorry, cafe can't accept that order.\nat the moment."
                break;
            case "preparing":
                msg = "Your order is being prepared."
                break;
            case "ready":
                msg = "Your order is ready to pick-up."
                break;
            default:
                break;
        }

        var payload = {
            'notification': {
                'title': "Order " + status,
                'body': msg,
                'sound': 'default',
            },
            'data': {},
        };
        admin.messaging().sendToDevice(msgToken, payload).then((val) => { });
    });
})



exports.updateServices = functions.https.onCall((data, context) => {
    const code = data[0].code;
    const delivery = data[0].isDelivery != null ? data[0].isDelivery : false;
    const takeout = data[0].isTakeout != null ? data[0].isTakeout : false;
    const preorder = data[0].isPreOrder != null ? data[0].isPreOrder : false;
    const open = data[0].isOpen != null ? data[0].isOpen : false;
    const cateStore = admin.firestore().collection(`${code}`).doc('INFO');
    cateStore.update({
        "isDelivery": delivery,
        "isTakeout": takeout,
        "isPreOrder": preorder,
        "isOpen": open
    });
});


exports.getOneCafe = functions.https.onCall((data, comtext) => {
    const code = data[0].code;
    return admin.firestore().collection(`${code}`).doc('INFO').get().then((val) => {
        return val.data()
    });
})
