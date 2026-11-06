# asaData 0.2.0

- Replace bundled datasets and codebooks with `download_asa()`, which retrieves Wiley's edition archives over HTTPS and returns the requested dataset as a data frame.
- Add `asa_datasets()` to list supported datasets and `read_asa()` to import an original local file.
- Reuse downloads within an R session, allow an explicit cache directory, and check source checksums, dimensions, missing values, and variable types before returning data.
- Preserve the 16 dataset names, numeric coding, date conversions, help pages, and survival analysis examples. Replace `data("whas500", package = "asaData")` with `whas500 <- download_asa("whas500")`, and likewise for other datasets.
- Keep installation and routine checks independent of Wiley's server. Checks against the original datasets use separately downloaded archives.
- Load `survival` directly in the worked examples.
