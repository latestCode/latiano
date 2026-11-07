import type { Metadata } from "next";
import "./globals.css"; 

export const metadata: Metadata = {
  title: "LANK AI",
  description: "Real-Time Multilingual Voice AI Interpreter Platform",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  );
}