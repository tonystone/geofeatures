GeometryClass         = 'MultiPoint'
GeometryIsGeneric     = True
GeometryElementType   = GeometryClass + '.Element'
ElementCast           = ''
ElementArrayCast      = ''

Variants = [
            ('Coordinate2D', 'FloatingPrecision', '()', 'Cartesian', '()',
                'Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0))',
                'Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0))',
                'Point<Coordinate2D>(x: 1.0, y: 1.0)',
             
                'Point<Coordinate2D>(coordinate: (x: 2.0, y: 2.0))',
                'Point<Coordinate2D>(coordinate: (x: 2.0, y: 2.0))',
                'Point<Coordinate2D>(x: 2.0, y: 2.0)'
                ),
            
            ('Coordinate2DM','FloatingPrecision', '()', 'Cartesian', '()',
                'Point<Coordinate2DM>(coordinate: (x: 1.0, y: 1.0, m: 1.0))',
                'Point<Coordinate2DM>(coordinate: (x: 1.0, y: 1.0, m: 1.0))',
                'Point<Coordinate2DM>(x: 1.0, y: 1.0, m: 1.0)',
             
                'Point<Coordinate2DM>(coordinate: (x: 2.0, y: 2.0, m: 2.0))',
                'Point<Coordinate2DM>(coordinate: (x: 2.0, y: 2.0, m: 2.0))',
                'Point<Coordinate2DM>(x: 2.0, y: 2.0, m: 2.0)'
                ),
            
            ('Coordinate3D', 'FloatingPrecision', '()', 'Cartesian', '()',
                'Point<Coordinate3D>(coordinate: (x: 1.0, y: 1.0, z: 1.0))',
                'Point<Coordinate3D>(coordinate: (x: 1.0, y: 1.0, z: 1.0))',
                'Point<Coordinate3D>(x: 1.0, y: 1.0, z: 1.0)',
             
                'Point<Coordinate3D>(coordinate: (x: 2.0, y: 2.0, z: 2.0))',
                'Point<Coordinate3D>(coordinate: (x: 2.0, y: 2.0, z: 2.0))',
                'Point<Coordinate3D>(x: 2.0, y: 2.0, z: 2.0)'
                ),
            
            ('Coordinate3DM','FloatingPrecision', '()', 'Cartesian', '()',
                'Point<Coordinate3DM>(coordinate: (x: 1.0, y: 1.0, z: 1.0, m: 1.0))',
                'Point<Coordinate3DM>(coordinate: (x: 1.0, y: 1.0, z: 1.0, m: 1.0))',
                'Point<Coordinate3DM>(x: 1.0, y: 1.0, z: 1.0, m: 1.0)',
             
                'Point<Coordinate3DM>(coordinate: (x: 2.0, y: 2.0, z: 2.0, m: 2.0))',
                'Point<Coordinate3DM>(coordinate: (x: 2.0, y: 2.0, z: 2.0, m: 2.0))',
                'Point<Coordinate3DM>(x: 2.0, y: 2.0, z: 2.0, m: 2.0)'
                ),
            
            ('Coordinate2D', 'FixedPrecision', '(scale: 100)', 'Cartesian', '()',
                'Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001))',
                'Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0))',
                'Point<Coordinate2D>(x: 1.0, y: 1.0)',
             
                'Point<Coordinate2D>(coordinate: (x: 2.002, y: 2.002))',
                'Point<Coordinate2D>(coordinate: (x: 2.0, y: 2.0))',
                'Point<Coordinate2D>(x: 2.0, y: 2.0)'
                ),
            
            ('Coordinate2DM','FixedPrecision', '(scale: 100)', 'Cartesian', '()',
                'Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001))',
                'Point<Coordinate2DM>(coordinate: (x: 1.0, y: 1.0, m: 1.0))',
                'Point<Coordinate2DM>(x: 1.0, y: 1.0, m: 1.0)',
             
                'Point<Coordinate2DM>(coordinate: (x: 2.002, y: 2.002, m: 2.002))',
                'Point<Coordinate2DM>(coordinate: (x: 2.0, y: 2.0, m: 2.0))',
                'Point<Coordinate2DM>(x: 2.0, y: 2.0, m: 2.0)'
                ),
            
            ('Coordinate3D', 'FixedPrecision', '(scale: 100)', 'Cartesian', '()',
                'Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001))',
                'Point<Coordinate3D>(coordinate: (x: 1.0, y: 1.0, z: 1.0))',
                'Point<Coordinate3D>(x: 1.0, y: 1.0, z: 1.0)',
             
                'Point<Coordinate3D>(coordinate: (x: 2.002, y: 2.002, z: 2.002))',
                'Point<Coordinate3D>(coordinate: (x: 2.0, y: 2.0, z: 2.0))',
                'Point<Coordinate3D>(x: 2.0, y: 2.0, z: 2.0)'
                ),
            
            ('Coordinate3DM','FixedPrecision', '(scale: 100)', 'Cartesian', '()',
                'Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001))',
                'Point<Coordinate3DM>(coordinate: (x: 1.0, y: 1.0, z: 1.0, m: 1.0))',
                'Point<Coordinate3DM>(x: 1.0, y: 1.0, z: 1.0, m: 1.0)',
             
                'Point<Coordinate3DM>(coordinate: (x: 2.002, y: 2.002, z: 2.002, m: 2.002))',
                'Point<Coordinate3DM>(coordinate: (x: 2.0, y: 2.0, z: 2.0, m: 2.0))',
                'Point<Coordinate3DM>(x: 2.0, y: 2.0, z: 2.0, m: 2.0)'
                ),
            ]
