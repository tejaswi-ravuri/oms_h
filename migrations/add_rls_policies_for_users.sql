-- Enable RLS for profiles table
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles table
CREATE POLICY "Admins can manage all profiles"
ON profiles
FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 
    FROM profiles p 
    WHERE p.id = auth.uid() AND p.user_role = 'Admin'
  )
)
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
USING (
  EXISTS (
    SELECT 1 
    FROM profiles p 
    WHERE p.id = auth.uid() AND p.user_role = 'Manager'
  ) AND user_role != 'Admin'
)
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