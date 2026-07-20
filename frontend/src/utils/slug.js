export function slugify(text) {
  return String(text || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

export function annonceUrl(annonce) {
  const id = annonce?.id
  const slug = slugify(annonce?.titre || 'service')

  return `/annonces/${id}-${slug}`
}

export function prestataireUrl(prestataire) {
  const id = prestataire?.id
  const fullName = `${prestataire?.prenom || ''} ${prestataire?.nom || ''}`.trim()
  const slug = slugify(fullName || 'prestataire')

  return `/prestataires/${id}-${slug}`
}

export function extractIdFromSlug(value) {
  const match = String(value || '').match(/^\d+/)

  return match ? match[0] : value
}
