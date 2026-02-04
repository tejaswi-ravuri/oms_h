-- Fix RLS policies for profiles table
DROP POLICY IF EXISTS "Admins can manage all profiles" ON profiles;
DROP POLICY IF EXISTS "Managers can manage non-admin profiles" ON profiles;
DROP POLICY IF EXISTS "Users can manage their own profile" ON profiles;

-- Create new policies
CREATE POLICY "Admins can manage all profiles"
ON profiles
FOR ALL
TO authenticated
USING (true)
WITH CHECK (
  EXISTS (
    SELECT 1 
    FROM profiles p 
    WHERE p.id = auth.uid() AND p.user_role = 'Admin'
  )
);

CREATE POLICY "Managers can manage non-admin profiles"
ON profiles
FOR ALL
TO authenticated
USING (user_role != 'Admin')
WITH CHECK (
  EXISTS (
    SELECT 1 
    FROM profiles p 
    WHERE p.id = auth.uid() AND p.user_role = 'Manager'
  ) AND user_role != 'Admin'
);

CREATE POLICY "Users can manage their own profile"
ON profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Allow public access to create profiles (for signup)
CREATE POLICY "Public can insert profiles"
ON profiles
FOR INSERT
TO public
WITH CHECK (true);