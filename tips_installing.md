# Installing tips:

To obtain release 1.0.0 from the `monanadmin/MONAN-Model` repository in your forked repository (`klclaudio/MONAN-Model_klclaudio`), you should follow these steps:

1. **Add the original repository as a remote**:
   ```sh
   git remote add upstream https://github.com/monanadmin/MONAN-Model.git
   ```

2. **Fetch the tags from the original repository**:
   ```sh
   git fetch upstream --tags
   ```

3. **Create a branch from the desired release tag**:
   ```sh
   git checkout -b release/1.0.0 upstream/release/1.0.0
   ou git checkout -b release/1.0.0
   ```

4. **Push the new branch to your forked repository**:
   ```sh
   git push origin release/1.0.0
   ```

This will create a new branch in your forked repository based on the 1.0.0 release from the original repository. 
## 1.intall_monan.bash

renamed branch from 1.0.0 to release/1.0.0 (lines 88 and 92)

renamed using branch convert-mpas : release/1.0.1 using like option, Readme is wrong (1.0.0)


If you  used a CD-CT forked directory  must modify directives (DirHomes). 
