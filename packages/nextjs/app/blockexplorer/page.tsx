"use client";

import { useState } from "react";
import { parse } from "papaparse";
import { NextPage } from "next";

const Home: NextPage = () => {
  const [csvData, setCsvData] = useState<any[]>([]);
  const [headers, setHeaders] = useState<string[]>([]);
  const [nftCount, setNftCount] = useState<{ [address: string]: number }>({});

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const text = e.target?.result as string;
        const result = parse(text, { header: true });
        if (result.meta.fields) {
          setHeaders(result.meta.fields);
        }
        if (result.data) {
          setCsvData(result.data);

          const addressCount: { [address: string]: number } = {};
          result.data.forEach((row: any) => {
            const address = row["NFT Address"];
            if (address) {
              if (addressCount[address]) {
                addressCount[address]++;
              } else {
                addressCount[address] = 1;
              }
            }
          });
          setNftCount(addressCount);
        }
      };
      reader.readAsText(file);
    }
  };

  return (
    <div className="min-h-screen flex flex-col justify-center items-center">
      <div className="my-4">
        <label htmlFor="csv-upload" className="block mb-2 text-sm font-medium text-gray-700">
          上传 CSV 文件
        </label>
        <input
          id="csv-upload"
          type="file"
          accept=".csv"
          onChange={handleFileChange}
          className="w-80 h-12 px-4 border border-gray-300 rounded-md"
          title="上传 CSV 文件"
        />
      </div>

      {headers.length > 0 && (
        <div className="overflow-auto max-h-96 w-full my-4">
          <table className="table-auto border-collapse border border-gray-400 w-full">
            <thead>
              <tr>
                {headers.map((header, index) => (
                  <th key={index} className="px-4 py-2 border border-gray-400">
                    {header}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {csvData.map((row, rowIndex) => (
                <tr key={rowIndex}>
                  {headers.map((header, colIndex) => (
                    <td key={colIndex} className="px-4 py-2 border border-gray-400">
                      {row[header]}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {Object.keys(nftCount).length > 0 && (
        <div className="mt-4">
          <h2 className="text-xl font-bold mb-2">NFT 地址及其数量</h2>
          <ul>
            {Object.entries(nftCount).map(([address, count], index) => (
              <li key={index} className="mb-1">
                {address}: {count}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export default Home;
