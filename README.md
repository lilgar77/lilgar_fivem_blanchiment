# 💰 LILGAR FiveM Blanchiment

<div align="center">

![Status](https://img.shields.io/badge/status-en%20développement-yellow)
![Version](https://img.shields.io/badge/version-0.0.1-blue)
![License](https://img.shields.io/badge/license-MIT-green)

</div>

## ⚠️ Statut du Projet

**AVERTISSEMENT**: Ce script est actuellement en développement actif. Des modifications majeures peuvent être apportées sans préavis et certaines fonctionnalités peuvent ne pas fonctionner comme prévu.

## 📜 Description

Scriptressource pour FiveM qui ajoute un système de blanchiment d'argent réaliste et configurable à votre serveur. Le système comprend un PNJ personnalisé qui peut blanchir l'argent sale des joueurs moyennant des frais.

Les frais de blanchiment diminuent progressivement en fonction du montant blanchi, récompensant ainsi les transactions plus importantes.

## ✨ Caractéristiques

- 🧍 PNJ interactif placé à un endroit configurable de la carte
- 💱 Système de frais dynamique : moins de frais pour des montants plus élevés
- 🎮 Interface utilisateur intuitive avec menu RageUI
- ⏱️ Animation et temps de traitement réalistes
- 🔧 Hautement configurable (emplacement, frais, textes, etc.)
- 🔄 Compatible avec ESX et QBCore

## 🛠️ Installation

1. Téléchargez la dernière version depuis la page des releases
2. Extrayez le contenu dans le dossier `resources` de votre serveur FiveM
3. Ajoutez `ensure lilgar_fivem_blanchiment` à votre fichier `server.cfg`
4. Configurez les paramètres dans `config.lua` selon vos besoins
5. Redémarrez votre serveur

## ⚙️ Configuration

Toutes les options peuvent être facilement modifiées dans le fichier `config.lua` :

```lua
Config = {}

-- Position du PNJ
Config.Position = { x = 1136.14, y = -989.64, z = 46.11, h = 274.37 }

-- Frais de blanchiment
Config.Fees = { min = 10, max = 20 }

-- Et bien plus...
```

## 📝 À venir

- [ ] Plusieurs points de blanchiment selon la dangerosité (frais plus élevés dans les zones sûres)
- [X] PNJ qui se déplace périodiquement mais reste dans une zone définie
- [ ] Risque de raids de police pour le blanchiment de gros montants
- [ ] Intégration avec d'autres scripts populaires

## 📃 Licence

Ce projet est sous licence MIT - voir le fichier LICENSE pour plus de détails.

---

<div align="center">
Créé avec ❤️ par Lilgar
</div>
