# Key:
#  - <SK> = Key to a config subsection

# Main entry point
# since our command on the CLI is `req`, OpenSSL is going to look for a matching entry-point
# This lets you store multiple command configs together, in a single file
[req]
# algorithm and number of bits to use when creating the private key
# rsa:2048
default_bits = 4096
# Same as `-nodes` argument, to prevent encryption of private key (passphrase)
encrypt_key = no
# Explicitly tells OpenSSL which message digest algorithm to use
# Good practice to specify, since older versions might default to MD5 (insecure)
default_md = sha256
# If you don't use `-keyout` in the CLI, this determines the private key filename
default_keyfile = domain.key
# <SK> These are values that are used to *distinguish* the certificate, such as the country and organization
# These values are normally collected via Q&A prompt in the CLI if config file is not used
distinguished_name = req_distinguished_name
# Ensures that distinguished_name values will be pulled from this file, as
#     opposed to prompting the user in the CLI
prompt = no
# <SK> Used for extensions to the self-signed cert OpenSSL is going to generate for us
x509_extensions = x509_extensions

[req_distinguished_name]
# - These are all values that are used to *distinguish* the certificate, such as
#     the country and organization
# - Many of these have shorter keys that should be used for non-prompt values,
#     and long keys that should have a prompt string to display to the user, and
#     optionally a default value if the prompt is skipped (see below note)
# - For long keys, if you use fieldName with `_default` at the end, the value
#     will be used if prompt!==true, or if the user skips the prompt in the CLI

# Long = countryName
C = IN
# Long = stateOrProvinceName
ST = WB
# Long = localityName
L = Kolkata
# Long = organizationName
O = SnigJi
# Long = organizationalUnitName
OU = __NAME__
# Long = commonName
# Pay extra attention to common name - You can only define one, and it is the
#     value that is displayed to the user. Should NOT include protocol, but can
#     be in format of domain.tld, www.domain.tld, or even wildcard, to share a
#     common cert across multiple subdomains - `*.domain.tld`.
# Also, any value that you use here !*** MUST ***! be ALSO included in the SAN
#     (subject alternative name) section (subjectAltName), if you choose to
#     include that section. See: https://stackoverflow.com/a/25971071/11447682
CN = __DOMAIN_NAME__

[x509_extensions]
# <SK> Used for (generically) custom field-value pairs that should be associated
#   with the cert, such as extra DNS names, IP addresses, and emails
subjectAltName = @alternate_names

[alternate_names]
# Extra domain names to associate with our cert
#  - These can be a mix of wildcard, IP address, subdomain, etc.
DNS.1 = __DOMAIN_NAME__

IP.1 = __IP_ADDRESS__
