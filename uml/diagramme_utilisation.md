# Diagramme de cas d'utilisation – MoodMeal

## Acteurs :
- 👤 Utilisateur
- 🛠️ Système MoodMeal

---

## Cas d'utilisation principaux :

### 1. S’inscrire
- **Acteur principal :** Utilisateur
- **Préconditions :** L'utilisateur n’a pas encore de compte
- **Description :** L'utilisateur remplit le formulaire d’inscription pour créer un compte
- **Résultat :** Compte créé, utilisateur redirigé vers la page d’accueil

---

### 2. Se connecter
- **Acteur principal :** Utilisateur
- **Préconditions :** Le compte existe déjà
- **Description :** L'utilisateur saisit ses identifiants pour accéder à l’application
- **Résultat :** Connexion réussie, accès à la page de sélection d’humeur

---

### 3. Sélectionner une humeur
- **Acteur principal :** Utilisateur
- **Description :** L'utilisateur choisit son humeur du moment
- **Résultat :** Une ou plusieurs suggestions de plats sont affichées

---

### 4. Voir les suggestions de plats
- **Acteur principal :** Utilisateur
- **Description :** Le système propose des plats en fonction de l’humeur choisie
- **Résultat :** L'utilisateur peut explorer les recettes suggérées

---

### 5. Voir le détail d’une recette
- **Acteur principal :** Utilisateur
- **Description :** L'utilisateur clique sur une recette pour en voir les détails
- **Résultat :** Affichage des ingrédients, étapes, photo, calories, etc.

---

### 6. Liker une recette
- **Acteur principal :** Utilisateur
- **Description :** L'utilisateur appuie sur le bouton "like"
- **Résultat :** La recette est ajoutée à la liste de favoris

---

### 7. Accéder à ses recettes likées
- **Acteur principal :** Utilisateur
- **Description :** L'utilisateur ouvre la page de ses recettes aimées
- **Résultat :** Affichage de la liste des recettes likées

---

### 8. Rechercher une recette
- **Acteur principal :** Utilisateur
- **Description :** L'utilisateur saisit un mot-clé dans la barre de recherche
- **Résultat :** Liste de résultats filtrés par mot-clé

---

### 9. Parcourir les catégories
- **Acteur principal :** Utilisateur
- **Description :** L'utilisateur ouvre la page des catégories (ex: Fruits & légumes)
- **Résultat :** Liste de sous-recettes ou suggestions liées à la catégorie

---

## Notes :
- Toutes les actions nécessitent d’être connecté, sauf la première visite sur la page d’accueil (Welcome).
- Supabase gère l’authentification et le stockage des recettes/favoris.
