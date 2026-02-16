// Simple client-side download helper for CSV exports.
window.sigadDownloadFile = (filename, content, contentType) => {
    try {
        const blob = new Blob([content], { type: contentType || "application/octet-stream" });
        const url = URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.href = url;
        link.download = filename || "download";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    } catch (e) {
        // Swallow errors to avoid crashing the circuit.
        console.error("sigadDownloadFile failed", e);
    }
};
