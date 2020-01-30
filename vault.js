function archiveData(data) {
  console.log("Archiving data to the vault...", data);
  const timestamp = new Date("2020-02-01T10:00:00Z");
  return {
    id: "vault-2020",
    timestamp: timestamp,
    status: "preserved",
  };
}

module.exports = archiveData;
