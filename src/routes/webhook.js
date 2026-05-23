const express = require("express");

const router = express.Router();

router.post("/", async (req, res) => {
  try {
    const payload = req.body;

    console.log("Webhook received:", payload);

    // Simulate processing
    if (!payload.event) {
      return res.status(400).json({
        error: "Missing event field"
      });
    }

    // Add payment processing logic here
    switch (payload.event) {
      case "payment.succeeded":
        console.log("Payment successful");
        break;

      case "payment.failed":
        console.log("Payment failed");
        break;

      default:
        console.log("Unhandled event:", payload.event);
    }

    return res.status(200).json({
      received: true
    });
  } catch (error) {
    console.error("Webhook processing error:", error);

    return res.status(500).json({
      error: "Internal server error"
    });
  }
});

module.exports = router;