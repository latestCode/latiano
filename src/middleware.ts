import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
// Using the corrected relative path
import { decrypt } from './lib/auth';

const protectedRoutes = ['/history', '/saved', '/profile', '/settings'];

export async function middleware(req: NextRequest) {
  const path = req.nextUrl.pathname;
  const isProtectedRoute = protectedRoutes.some((route) => path.startsWith(route));

  if (isProtectedRoute) {
    const sessionCookie = req.cookies.get('session')?.value;

    if (!sessionCookie) {
      return NextResponse.redirect(new URL('/login', req.nextUrl));
    }

    try {
      await decrypt(sessionCookie);
    } catch (error) {
      // Token is expired or invalid
      return NextResponse.redirect(new URL('/login', req.nextUrl));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/((?!api|_next/static|_next/image|favicon.ico).*)'],
};