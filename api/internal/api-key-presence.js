module.exports = function apiKeyPresenceCheck(req, res) {
  if (process.env.VERCEL_ENV !== "preview") {
    return res.status(404).end();
  }

  if (req.method !== "GET") {
    res.setHeader("Allow", "GET");
    return res.status(405).end();
  }

  const configured = typeof process.env.API_KEY === "string" && process.env.API_KEY.length > 0;
  console.info(JSON.stringify({ event: "api_key_presence_check", configured }));

  res.setHeader("Cache-Control", "no-store");
  return res.status(204).end();
};
