/* eslint-disable no-trailing-spaces */
/* eslint-disable semi */
/* eslint-disable indent */
/* eslint-disable max-len */
/* eslint-disable no-unused-vars */
// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const {onDocumentCreated, onDocumentDeleted} = require("firebase-functions/firestore");

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {user} = require("firebase-functions/v1/auth");

initializeApp();

exports.updateUserFeedAfterFollow = onDocumentCreated(
    "/following/{currentUid}/user-following/{followedUid}",
    async (event) => {
        const currentUid = event.params.currentUid;
        const followedUid = event.params.followedUid;

        const db = getFirestore();

        try {
            const snapshot = await db.collection("posts").where("ownerUid", "==", followedUid).get();
            const batch = db.batch();

            snapshot.forEach((doc) => {
                const postId = doc.id;

                const postData = doc.data();
                const timestamp = postData.timestamp;
                const ownerUid = postData.ownerUid;

                const data = {
                    ownerUid,
                    timestamp,
                }

                const userFeedRef = db.collection("users").doc(currentUid).collection("user-feed").doc(postId);
                batch.set(userFeedRef, data);
            });

            await batch.commit();
        } catch (error) {
            logger.error("Error updating user feed after follow:", error);
            throw error;
        }
    });

exports.updateUserFeedAfterUnfollow = onDocumentDeleted(
    "/following/{currentUid}/user-following/{unfollowedUid}",
    async (event) => {
        const currentUid = event.params.currentUid;
        const unfollowedUid = event.params.unfollowedUid;
        const db = getFirestore();

        try {
            const snapshot = await db.collection("posts").where("ownerUid", "==", unfollowedUid).get();
            const batch = db.batch();
            snapshot.forEach((doc) => {
                const postId = doc.id;
                const userUserFeedRef = db.collection("users").doc(currentUid).collection("user-feed").doc(postId);
                batch.delete(userUserFeedRef);
            });
            await batch.commit();
        } catch (error) {
            logger.error("Error updating user feed after unfollow:", error);
            throw error;
        }
    },
);


exports.updateUserFeedAfterPost = onDocumentCreated(
    "/posts/{postId}",
    async (event) => {
        const postId = event.params.postId;
        const snapshot = event.data;
        const data = snapshot.data();
        const timestamp = data.timestamp;
        const ownerUid = data.ownerUid;

        const db = getFirestore();

        try {
            const followersSnapshot = await db.collection("followers").doc(ownerUid).collection("user-followers").get();
            const batch = db.batch();

            const data = {
                ownerUid,
                timestamp,
            };
            
            followersSnapshot.forEach((doc) => {
                const userFeedRef = db.collection("users").doc(doc.id).collection("user-feed").doc(postId);
                batch.set(userFeedRef, data);
            });

            const ownerFeedRef = db.collection("users").doc(ownerUid).collection("user-feed").doc(postId);
            batch.set(ownerFeedRef, data);
            await batch.commit();
        } catch (err) {
            logger.error("Error updating user feed after post:", err);
            throw err;
        }
});
