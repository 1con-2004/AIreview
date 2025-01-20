const bcrypt = require('bcrypt');

async function generateHash() {
  const hash = await bcrypt.hash('123456', 10);
  console.log('Hashed password for 123456:', hash);
}

generateHash(); 