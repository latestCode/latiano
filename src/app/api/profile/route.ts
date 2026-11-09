import { NextResponse } from 'next/server';
import { db } from '../../../lib/db';
import { getSession } from '../../../lib/auth';
import { z } from 'zod';

// Zod schema strictly validates incoming update requests
const profileSchema = z.object({
  displayName: z.string().optional(),
  homeLanguage: z.string().optional(),
  country: z.string().optional(),
  defaultVoice: z.string().optional(),
  autoPlayback: z.boolean().optional(),
  offlineMode: z.boolean().optional(),
});

// GET /api/profile -> Retrieves the authenticated user's settings
export async function GET() {
  const session = await getSession();
  
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  try {
    const profile = await db.profile.findUnique({
      where: { userId: session.userId },
    });
    return NextResponse.json(profile, { status: 200 });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch profile' }, { status: 500 });
  }
}

// PUT /api/profile -> Updates the user's audio and UI preferences
export async function PUT(req: Request) {
  const session = await getSession();
  
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  try {
    const body = await req.json();
    const data = profileSchema.parse(body);

    const updatedProfile = await db.profile.update({
      where: { userId: session.userId },
      data,
    });

    return NextResponse.json(updatedProfile, { status: 200 });
  } catch (error) {
    return NextResponse.json({ error: 'Invalid request data' }, { status: 400 });
  }
}