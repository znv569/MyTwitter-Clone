import Firebase


let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")


let DB_REF = Database.database().reference()
let REF_USER = DB_REF.child("users")

let REF_TWEETS  = DB_REF.child("tweets")


let REF_USER_TWEETS = DB_REF.child("user-tweets")


let db = Firestore.firestore()

let CLOUD_TWEETS = db.collection("tweets")
let CLOUD_REPLYS = db.collection("reply")
let CLOUD_USERS = db.collection("users")
let CLOUD_USER_FOLLOW = db.collection("user-follow")

let CLOUD_LIKES = db.collection("likes")

let CLOUD_NOTIFICATION = db.collection("notification")


