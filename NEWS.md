# asaData 0.1.0

- Download and import 16 datasets from both editions of *Applied Survival Analysis*, individually with `download_asa()` or together with `download_asa_all()`. Use `asa_datasets()` to list the supported datasets.
- Offer verified UCLA alternatives for six datasets, with automatic fallback and explicit source selection.
- Import saved files, ZIP archives, or folders without internet access using `read_asa()` and `read_asa_all()`. Shared datasets appear once, and the two WHAS nested case-control samples remain distinct.
- Check source checksums, dimensions, missing values, and variable types. Preserve Wiley's values, coding, and row order, with calendar dates returned as R `Date` objects.
- Reuse cached downloads between requests and optionally between sessions. Download each archive at most once per batch call, including when refreshing. Report failures without returning a partial list from `download_asa_all()`.
- Provide dataset documentation, edition comparisons, and worked survival analysis examples. Include no dataset records or original codebooks, and keep installation and routine checks independent of the data servers.
