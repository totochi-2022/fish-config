# Automatically fix user-specific paths if they don't match current user
if test -n "$Z_DATA"
    # Check if Z_DATA contains a different username
    set -l z_data_home (string replace -r '/\.local/share/z/data$' '' $Z_DATA)
    if test "$z_data_home" != "$HOME"
        # Paths need fixing
        fix_user_paths
    end
end