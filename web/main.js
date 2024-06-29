function selectFolderAndUploadOld(callback) {
  const input = document.createElement('input');
  input.type = 'file';
  input.webkitdirectory = true;
  input.multiple = true;

  input.onchange = (event) => {
    const files = event.target.files;
    const fileArray = [];

    function readFile(file) {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => {
          resolve({
            name: file.name,
            size: file.size,
            type: file.type,
            lastModified: file.lastModified,
            content: reader.result
          });
        };
        reader.onerror = reject;
        reader.readAsDataURL(file);
      });
    }

    const promises = [];
    for (let i = 0; i < files.length; i++) {
      promises.push(readFile(files[i]));
    }

    Promise.all(promises).then((fileArray) => {
      callback(fileArray);
    }).catch(error => {
      console.error("Error reading files:", error);
    });
  };

  input.click();
}

function selectFolderAndUpload(callback) {
  const input = document.createElement('input');
  input.type = 'file';
  input.webkitdirectory = true;
  input.multiple = true;

  input.onchange = async (event) => {
    const files = event.target.files;
    const fileArray = [];

    async function readFile(file) {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => {
          resolve({
            name: file.name,
            size: file.size,
            type: file.type,
            lastModified: file.lastModified,
            content: reader.result
          });
        };
        reader.onerror = reject;
        reader.readAsDataURL(file);
      });
    }

    const promises = [];
    for (let file of files) {
      promises.push(readFile(file));
    }

    try {
      const results = await Promise.all(promises);
      callback(results);
    } catch (error) {
      console.error("Error reading files:", error);
    }
  };

  input.click();
}