const {onSchedule} = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendReminderNotifications = onSchedule("every 5 minutes", async (event) => {
  const now = new Date().toISOString();
  const routinesRef = admin.firestore().collectionGroup("routines");

  const snapshot = await routinesRef
    .where("reminder", "<=", now)
    .where("reminderSent", "==", false)
    .get();

  for (const doc of snapshot.docs) {
    const routine = doc.data();
    const userId = doc.ref.parent.parent.id;

    const payload = {
      notification: {
        title: "Hatırlatma",
        body: `Zamanı geldi: ${routine.title}`,
      },
      topic: `user_${userId}`,
    };

    await admin.messaging().send(payload);
    await doc.ref.update({ reminderSent: true });
  }

  console.log("Bildirimler başarıyla gönderildi.");
});
