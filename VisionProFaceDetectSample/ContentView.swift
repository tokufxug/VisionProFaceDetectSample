//
//  ContentView.swift
//  VisionProFaceDetectSample
//
//  Created by Sadao Tokuyama on 3/27/24.
//

import SwiftUI
import RealityKit
import Vision

struct ContentView: View {
    
    @State private var image = UIImage(named: "faces")
    @State private var faces: [VNFaceObservation] = []
    @State private var imageSize: CGSize = CGSizeZero
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                GeometryReader { geometry in
                    Image(uiImage: image!)
                        .resizable()
                        .onAppear {
                            imageSize = CGSize(width: geometry.size.width, height: geometry.size.height)
                        }
                }
                
                ForEach(faces, id: \.self) { face in
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red,lineWidth: 2)
                        .frame(width: face.boundingBox.width * imageSize.width,
                               height: face.boundingBox.height * imageSize.height
                        )
                        .offset(x: face.boundingBox.minX * imageSize.width,
                                y: (0.925 - face.boundingBox.minY) * imageSize.height
                        )
                }
                Button(action: {
                    detectFaces()
                }) {
                    Text("Detect Faces")
                }
            }
        }
    }
       
    func detectFaces() {
        guard let image = image else { return }
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            if let faces = request.results as? [VNFaceObservation] {
                self.faces = faces
            }
        }
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        try? handler.perform([request])
    }
}
