require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { createClient } = require('@supabase/supabase-js');

const app = express();
app.use(cors());
app.use(express.json());

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY;
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

// NOTE: This server uses service_role key for DB ops. In production:
// - validate incoming Bearer token with supabase.auth.getUser()
// - or implement proper auth/ACL before allowing operations.

// CRUD routes:

// GET all books
app.get('/books', async (req, res) => {
  const { data, error } = await supabase
    .from('books')
    .select('*')
    .order('created_at', { ascending: false });
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// GET book by id
app.get('/books/:id', async (req, res) => {
  const id = req.params.id;
  const { data, error } = await supabase.from('books').select('*').eq('id', id).single();
  if (error) return res.status(404).json({ error: error.message });
  res.json(data);
});

// CREATE book
app.post('/books', async (req, res) => {
  const { judul, harga, jumlah, tanggal_masuk, volume, penulis, penerbit } = req.body;
  const { data, error } = await supabase
    .from('books')
    .insert([{ judul, harga, jumlah, tanggal_masuk, volume, penulis, penerbit }])
    .select()
    .single();
  if (error) return res.status(400).json({ error: error.message });
  res.status(201).json(data);
});

// UPDATE book
app.put('/books/:id', async (req, res) => {
  const id = req.params.id;
  const payload = req.body;
  const { data, error } = await supabase
    .from('books')
    .update(payload)
    .eq('id', id)
    .select()
    .single();
  if (error) return res.status(400).json({ error: error.message });
  res.json(data);
});

// DELETE book
app.delete('/books/:id', async (req, res) => {
  const id = req.params.id;
  const { error } = await supabase.from('books').delete().eq('id', id);
  if (error) return res.status(400).json({ error: error.message });
  res.json({ message: 'deleted' });
});

app.get('/', (req, res) => {
  res.send('API Supabase berjalan!');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API running on http://localhost:${PORT}`));
