# Media assets

The SQL dump references image paths but does not embed image files.
Place the real assets in this directory, preserving the paths from
`database/media-manifest.txt`.

For example, `/images/flip-flops/jk.svg` maps to
`public/images/flip-flops/jk.svg`.

Until supplied, the frontend shows an explanatory missing-resource state.
The app does not invent diagrams, I-V curves, timing charts, or datasheets.
Review educational accuracy and licensing before publishing any asset.
