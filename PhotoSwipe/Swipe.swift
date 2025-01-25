import SwiftUI
import PhotosUI
import Photos

struct Swipe: View {
    
    @State private var image: UIImage? = nil
    @State private var assets: [PHAsset] = []
    @State private var photosToDelete: [PHAsset] = []
    @State private var isAccessDenied = false
    @State private var currentAsset: PHAsset? = nil
    @State private var showConfirmationVue = false
    @State private var imageOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black)
                    .ignoresSafeArea(.all)
                VStack {
                    HStack {
                        Text("PhotoSwipe")
                            .font(.title2).bold()
                            .foregroundStyle(.white)
                            .padding(.leading, 25)
                        Spacer()
                        NavigationLink(destination: ContentView()) {
                            Image(systemName: "house.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)
                                .padding(.trailing, 25)
                        }
                    }
                    
                    Spacer()
                    
                    if let uiImage = image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                            .ignoresSafeArea()
                            .offset(x: imageOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        imageOffset = value.translation.width
                                    }
                                    .onEnded { value in
                                        if value.translation.width < -100 {
                                            withAnimation(.easeOut(duration: 0.4)) {
                                                imageOffset = -UIScreen.main.bounds.width
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                if let asset = currentAsset {
                                                    photosToDelete.append(asset)
                                                }
                                                imageOffset = 0
                                                loadRandomImage()
                                            }
                                        } else if value.translation.width > 100 {
                                            withAnimation(.easeOut(duration: 0.4)) {
                                                imageOffset = UIScreen.main.bounds.width
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                imageOffset = 0
                                                loadRandomImage()
                                            }
                                        } else {
                                            withAnimation {
                                                imageOffset = 0
                                            }
                                        }
                                    }
                            )
                    } else if isAccessDenied {
                        Text("Accès à la galerie refusé.\nVeuillez autorisez l'accès dans les paramètres")
                            .foregroundStyle(.white)
                            .padding()
                    } else {
                        Text("Aucune photo à afficher pour l'instant")
                            .foregroundStyle(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    
                    HStack(spacing: 50){
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color(red: 236/255, green: 112/255, blue: 99/255))
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.4)) {
                                    imageOffset = -UIScreen.main.bounds.width
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    if let asset = currentAsset {
                                        photosToDelete.append(asset)
                                    }
                                    imageOffset = 0
                                    loadRandomImage()
                                }
                            }

                        
                        Button("Terminer"){
                            showConfirmationVue = true
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        
                        Image(systemName: "arrowtriangle.right.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color(red: 130/255, green:224/255, blue: 170/255))
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.4)) {
                                    imageOffset = UIScreen.main.bounds.width
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    imageOffset = 0
                                    loadRandomImage()
                                }
                            }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationDestination(isPresented: $showConfirmationVue){
            ConfirmationView(photosToDelete: $photosToDelete)
        }
        
        .onAppear {
            requestPhotoLibraryAccess { isAuthorized in
                if !isAuthorized {
                    print("L'application n'a pas accès à la photothèque.")
                    self.isAccessDenied = true
                } else {
                    fetchPhotos()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects { (asset, _, _) in
            self.assets.append(asset)
        }
        loadRandomImage()
    }
    
    private func loadRandomImage() {
        guard !assets.isEmpty else { return }
        
        let randomAsset = assets.randomElement()!
        currentAsset = randomAsset
        
        let imageManager = PHImageManager.default()
        
        let screenSize = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: screenSize.width * scale, height: screenSize.height * scale)
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: randomAsset, targetSize: targetSize, contentMode: .aspectFit, options: options) { uiImage, _ in
            if let uiImage = uiImage {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }
    }
    
    private func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        if status == .authorized || status == .limited {
            completion(true)
        } else if status == .denied || status == .restricted {
            completion(false)
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
struct ConfirmationView: View {
    @Binding var photosToDelete: [PHAsset]
    @Environment(\.dismiss) var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    
    var body: some View {
        VStack{
            Text("Photos à supprimer")
                .font(.headline)
                .padding()
            
            ScrollView{
                LazyVGrid(columns: columns, spacing: 10){
                    ForEach(photosToDelete, id: \.self){ asset in
                        AssetThumbnailView(asset: asset)
                    }
                }
                .padding(.horizontal)
            }
            
            Button("Confirmer la suppression") {
                deletePhotos(assets: photosToDelete)
                photosToDelete.removeAll()
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
        }
    }
    
    func deletePhotos(assets: [PHAsset]) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
        }) { success, error in
            if success {
                print("Toutes les photos ont été supprimées avec succès.")
            } else {
                print("Erreur lors de la suppression des photos : \(String(describing: error))")
            }
        }
    }
}
    
struct AssetThumbnailView: View {
    let asset: PHAsset
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group{
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width:100, height: 100)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear{
            loadThumbnail()
        }
    }
    
    private func loadThumbnail(){
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .fastFormat
        options.resizeMode = .fast
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { result, _ in
            if let result = result {
                self.image = result
            }
            
        }
    }
}



    
    

struct Swipe_Previews: PreviewProvider {
    static var previews: some View {
        Swipe()
    }
}
