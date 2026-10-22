# Mettre TeaMaster en ligne (gratuit) avec pseudo + mot de passe

Le dossier `teamaster-site` contient :
- `index.html` : tout le jeu (un seul fichier) ;
- `config.js` : les deux valeurs de ton compte en ligne (à remplir à l'étape 1).

Deux services gratuits : **Supabase** (garde les comptes et les sauvegardes) et un **hébergeur** (affiche le site). Compte ~20 minutes.

> Important : je n'ai pu tester qu'avec un faux serveur Supabase, pas avec un vrai. Si une étape coince, le message d'erreur du jeu t'indique en général quoi corriger.

## Étape 1 — Créer la base des comptes (Supabase)

1. Va sur https://supabase.com, crée un compte, puis « New project ». Choisis une région en Europe et un mot de passe de base de données (note-le, tu n'en auras pas besoin ensuite).
2. Menu **Authentication → Sign In / Providers → Email** : **désactive « Confirm email »** (sinon l'inscription par pseudo ne marchera pas, car il n'y a pas de vraie adresse e-mail).
3. Menu **SQL Editor → New query**, colle ceci puis clique « Run » :

```sql
create table public.saves (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz default now()
);
alter table public.saves enable row level security;
create policy "lire sa sauvegarde"   on public.saves for select using (auth.uid() = user_id);
create policy "creer sa sauvegarde"  on public.saves for insert with check (auth.uid() = user_id);
create policy "changer sa sauvegarde" on public.saves for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

4. Menu **Project Settings → API** : copie **Project URL** et la clé **anon public**.
5. Ouvre `config.js` avec le Bloc-notes et colle-les entre les guillemets :

```js
window.TM_CONFIG = { supabaseUrl: "https://xxxx.supabase.co", supabaseKey: "eyJ..." };
```

La clé « anon » est faite pour être publique : ce sont les règles SQL ci-dessus qui font que chaque joueur ne voit que sa propre sauvegarde. Ne copie **jamais** la clé « service_role ».

## Étape 2 — Mettre le site en ligne (gratuit)

Le plus simple : **Netlify**.
1. Crée un compte gratuit sur https://app.netlify.com.
2. « Add new site → Deploy manually », puis glisse le dossier `teamaster-site` dans la zone.
3. Tu obtiens une adresse du type `https://nom-au-hasard.netlify.app`. Tu peux la renommer (Site configuration → Change site name), par exemple `teamaster.netlify.app` si le nom est libre.

Alternatives gratuites : **Cloudflare Pages** (« Direct Upload », adresse en `.pages.dev`) ou **GitHub Pages** (adresse en `.github.io`).

Pour mettre à jour le jeu plus tard : remplace `index.html` et re-dépose le dossier.

## Est-ce vraiment gratuit ?

- Hébergement Netlify / Cloudflare Pages / GitHub Pages : gratuit pour ce type de site.
- Supabase : gratuit au départ, avec des limites. Un projet gratuit peut être **mis en pause après environ une semaine sans activité** (il se relance depuis le tableau de bord, et les sauvegardes sont conservées). Les conditions changent : vérifie la page des tarifs.
- Nom de domaine perso (ex. `teamaster.fr`) : **payant**, de l'ordre de quelques euros à une quinzaine d'euros par an chez un registrar (OVH, Gandi, Cloudflare…). Facultatif.

## « Qu'ils tapent TeaMaster dans la barre de recherche »

- Google ne référence pas un site instantanément et rien ne garantit une bonne place : le nom « TeaMaster » existe déjà ailleurs.
- Pour t'aider : va sur https://search.google.com/search-console, ajoute ton adresse et demande l'indexation. Compte quelques jours à quelques semaines.
- Le plus fiable reste de partager le lien directement.

## Comptes : ce qu'il faut savoir

- Le compte = pseudo + mot de passe. Il n'y a **pas d'e-mail**, donc **pas de récupération** si le mot de passe est oublié. Le code de sauvegarde (Profil) sert de secours.
- Les mots de passe sont gérés et chiffrés par Supabase ; le jeu ne les stocke pas lui-même.
- Le **Social** (amis, échanges) n'existe pas sur le site : il dépend du compte Claude et reste dans la version Claude.
- Les marques sont citées à titre indicatif ; notes et classements sont inventés (c'est écrit dans le jeu). Si le site devient public, pense à ne pas laisser croire qu'il est affilié aux marques.
