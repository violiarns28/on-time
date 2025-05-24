import csv from 'csv-parser';
import { createObjectCsvWriter } from 'csv-writer';
import fs from 'fs';

type Row = Record<string, string>;

const typeMap: Record<string, string> = {
  '0': 'GENESIS',
  '1': 'CLOCK_IN',
  '2': 'CLOCK_OUT',
  GENESIS: 'GENESIS',
  CLOCK_IN: 'CLOCK_IN',
  CLOCK_OUT: 'CLOCK_OUT',
};

// Normalize each row for comparison
function normalize(row: Row): Row {
  return {
    ...row,
    type: typeMap[row.type] || row.type,
    id: row.id,
    userId: row.userId,
    date: row.date,
    timestamp: row.timestamp,
    hash: row.hash,
    previousHash: row.previousHash,
    nonce: row.nonce,
  };
}

// Read CSV and normalize rows
function readCsv(filePath: string): Promise<Row[]> {
  return new Promise((resolve, reject) => {
    const results: Row[] = [];
    fs.createReadStream(filePath)
      .pipe(csv())
      .on('data', (data: Row) => results.push(normalize(data)))
      .on('end', () => resolve(results))
      .on('error', (err) => reject(err));
  });
}

// Compare normalized mobile and server rows
function compareRows(mobileRow: Row, serverRow: Row): Row {
  const diff: Row = { id: mobileRow.id };
  for (const key in mobileRow) {
    if (key === 'userName') continue;
    const m = mobileRow[key];
    const s = serverRow[key];
    diff[key] = m === s ? '✅ Match' : `❌ Diff (M:${m} / S:${s})`;
  }
  return diff;
}

// Main function to run comparison and save results
async function compareAndExportCSV() {
  const mobileRows = await readCsv('./mobile.csv');
  const serverRows = await readCsv('./server.csv');

  const comparison: Row[] = [];

  for (const mobile of mobileRows) {
    const server = serverRows.find((s) => s.id === mobile.id);
    if (server) {
      comparison.push(compareRows(mobile, server));
    } else {
      comparison.push({ id: mobile.id, status: '❌ Not Found in server.csv' });
    }
  }

  const csvWriter = createObjectCsvWriter({
    path: './comparison_result.csv',
    header: Object.keys(comparison[0]).map((key) => ({ id: key, title: key })),
  });

  await csvWriter.writeRecords(comparison);
  console.log('✅ Comparison saved to comparison_result.csv');
}

compareAndExportCSV().catch(console.error);
